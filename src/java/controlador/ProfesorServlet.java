package controlador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import modelo.Profesor;
import java.util.List;
import modelo.ProfesorDAO;

@WebServlet("/ProfesorServlet")
public class ProfesorServlet extends HttpServlet {

    private ProfesorDAO dao = new ProfesorDAO();

    @Override
    // En tu ProfesorServlet, modifica el doGet:

protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    System.out.println("=== PROFESOR SERVLET - doGet ===");
    System.out.println("Acción solicitada: " + request.getParameter("accion"));
    System.out.println("ID solicitado: " + request.getParameter("id"));
    
    HttpSession session = request.getSession();
    String rol = (String) session.getAttribute("rol");
    
    System.out.println("Rol del usuario: " + rol);
    
    if (!"admin".equals(rol)) {
        System.out.println("ACCESO DENEGADO");
        response.sendRedirect("acceso_denegado.jsp");
        return;
    }
    
    String accion = request.getParameter("accion");
    
    // Acción por defecto: listar todos los profesores
    if (accion == null || accion.equals("listar")) {
        System.out.println("Listando profesores...");
        try {
            List<Profesor> lista = dao.listar();
            System.out.println("Número de profesores encontrados: " + lista.size());
            request.setAttribute("lista", lista);
            request.getRequestDispatcher("profesores.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al listar profesores: " + e.getMessage());
            request.getRequestDispatcher("profesores.jsp").forward(request, response);
        }
        return;
    }
    
    System.out.println("Ejecutando acción: " + accion);
    
    // Ejecutar acción específica según parámetro
    try {
        switch (accion) {
            case "editar":
                System.out.println("=== INICIO EDICIÓN ===");
                int idEditar = Integer.parseInt(request.getParameter("id"));
                System.out.println("ID a editar: " + idEditar);

                Profesor p = dao.obtenerPorId(idEditar);
                System.out.println("Profesor encontrado: " + (p != null ? "SÍ" : "NO"));

                if (p != null) {
                    System.out.println("Nombre: " + p.getNombres() + " " + p.getApellidos());
                    System.out.println("Correo: " + p.getCorreo());
                    System.out.println("Especialidad: " + p.getEspecialidad());

                    request.setAttribute("profesor", p);
                    request.getRequestDispatcher("profesorForm.jsp").forward(request, response);
                } else {
                    System.out.println("ERROR: Profesor no encontrado con ID: " + idEditar);
                    session.setAttribute("error", "Profesor no encontrado");
                    response.sendRedirect("ProfesorServlet");
                }
                System.out.println("=== FIN EDICIÓN ===");
                break;

            case "eliminar":
                System.out.println("=== INICIO ELIMINACIÓN ===");
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                System.out.println("ID a eliminar: " + idEliminar);

                // Verifica que el profesor existe antes de eliminar
                Profesor profesorAEliminar = dao.obtenerPorId(idEliminar);
                if (profesorAEliminar == null) {
                    System.out.println("ERROR: No existe profesor con ID: " + idEliminar);
                    session.setAttribute("error", "El profesor no existe");
                    response.sendRedirect("ProfesorServlet");
                    break;
                }

                System.out.println("Profesor a eliminar: " + profesorAEliminar.getNombres() + " " + profesorAEliminar.getApellidos());
                boolean eliminado = dao.eliminar(idEliminar);
                System.out.println("Resultado eliminación: " + eliminado);

                if (eliminado) {
                    session.setAttribute("mensaje", "Profesor " + profesorAEliminar.getNombres() + 
                        " " + profesorAEliminar.getApellidos() + " eliminado correctamente");
                } else {
                    session.setAttribute("error", "No se pudo eliminar al profesor " + 
                        profesorAEliminar.getNombres() + " " + profesorAEliminar.getApellidos() + 
                        ". Puede tener registros relacionados.");
                }
                System.out.println("=== FIN ELIMINACIÓN ===");
                response.sendRedirect("ProfesorServlet");
                break;
                
            case "nuevo":
                System.out.println("Mostrando formulario nuevo...");
                request.getRequestDispatcher("profesorForm.jsp").forward(request, response);
                break;

            default:
                System.out.println("Acción no reconocida: " + accion);
                response.sendRedirect("ProfesorServlet");
        }
    } catch (NumberFormatException e) {
        System.err.println("Error de formato en ID: " + e.getMessage());
        session.setAttribute("error", "ID inválido: " + e.getMessage());
        response.sendRedirect("ProfesorServlet");
    } catch (Exception e) {
        System.err.println("Error en doGet: " + e.getMessage());
        e.printStackTrace();
        session.setAttribute("error", "Error: " + e.getMessage());
        response.sendRedirect("ProfesorServlet");
    }
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== PROFESOR SERVLET - doPost ===");
        
        // Obtener todos los parámetros con validación
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String correo = request.getParameter("correo");
        String especialidad = request.getParameter("especialidad");
        String dni = request.getParameter("dni");
        String telefono = request.getParameter("telefono");
        String idParam = request.getParameter("id");
        String accion = request.getParameter("accion"); // Nuevo parámetro para identificar acción
        
        System.out.println("Datos recibidos:");
        System.out.println("Acción: " + accion);
        System.out.println("Nombres: " + nombres);
        System.out.println("Apellidos: " + apellidos);
        System.out.println("Correo: " + correo);
        System.out.println("Especialidad: " + especialidad);
        System.out.println("DNI: " + dni);
        System.out.println("Teléfono: " + telefono);
        System.out.println("ID: " + idParam);

        // Validar campos requeridos
        if (nombres == null || nombres.trim().isEmpty() ||
            apellidos == null || apellidos.trim().isEmpty() ||
            correo == null || correo.trim().isEmpty() ||
            especialidad == null || especialidad.trim().isEmpty()) {
            
            HttpSession session = request.getSession();
            session.setAttribute("error", "Faltan campos obligatorios");
            response.sendRedirect("ProfesorServlet");
            return;
        }

        try {
            Profesor p = new Profesor();
            p.setNombres(nombres.trim());
            p.setApellidos(apellidos.trim());
            p.setCorreo(correo.trim());
            p.setEspecialidad(especialidad.trim());
            
            // Solo asignar DNI y teléfono si existen los métodos
            try {
                p.setDni(dni != null ? dni.trim() : "");
                p.setTelefono(telefono != null ? telefono.trim() : "");
            } catch (NoSuchMethodError e) {
                System.out.println("Advertencia: Métodos setDni o setTelefono no existen");
            }

            boolean resultado;
            String mensaje;
            
            if (idParam == null || idParam.isEmpty() || "0".equals(idParam)) {
                // Crear nuevo profesor
                resultado = dao.agregar(p);
                mensaje = resultado ? "Profesor registrado exitosamente" : "Error al registrar profesor";
            } else {
                // Actualizar profesor existente
                int id = Integer.parseInt(idParam);
                p.setId(id);
                resultado = dao.actualizar(p);
                mensaje = resultado ? "Profesor actualizado exitosamente" : "Error al actualizar profesor";
            }

            System.out.println("Resultado: " + resultado + " - Mensaje: " + mensaje);
            
            // Guardar mensaje en sesión
            HttpSession session = request.getSession();
            if (resultado) {
                session.setAttribute("mensaje", mensaje);
            } else {
                session.setAttribute("error", mensaje);
            }
            
            response.sendRedirect("ProfesorServlet");
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID inválido: " + e.getMessage());
            response.sendRedirect("ProfesorServlet");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error en el servidor: " + e.getMessage());
            response.sendRedirect("ProfesorServlet");
        }
    }
}