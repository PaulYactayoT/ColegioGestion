package controlador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import modelo.Grado;
import modelo.GradoDAO;
import java.util.List;

@WebServlet("/GradoServlet")
public class GradoServlet extends HttpServlet {

    GradoDAO dao = new GradoDAO();
  @Override
    public void init() throws ServletException {
        System.out.println("======================================");
        System.out.println("¡¡¡ SERVLET GradoServlet INICIALIZADO !!!");
        System.out.println("======================================");
    } 
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();
    
    // VALIDACIÓN CRÍTICA: Solo admin puede gestionar grados
    String rol = (String) session.getAttribute("rol");
    
    // ========== AGREGAR ESTOS LOGS ==========
    System.out.println("==========================================");
    System.out.println("GradoServlet.doGet() EJECUTADO");
    System.out.println("Acción: " + request.getParameter("accion"));
    System.out.println("Rol: " + rol);
    System.out.println("==========================================");
    // =========================================
    
    if (!"admin".equals(rol)) {
        response.sendRedirect("acceso_denegado.jsp");
        return;
    }

    String accion = request.getParameter("accion");

    if (accion == null || accion.isEmpty()) {
        // ========== LOG IMPORTANTE ==========
        System.out.println("Cargando lista de grados...");
        System.out.println("Llamando a dao.listar()...");
        // ====================================
        
        List<Grado> lista = dao.listar();  // <-- Asegúrate de obtener la lista
        
        // ========== LOG PARA VER LA LISTA ==========
        System.out.println("Tamaño de lista: " + (lista != null ? lista.size() : "null"));
        if (lista != null && !lista.isEmpty()) {
            for (Grado grado : lista) {
                System.out.println("Grado: " + grado.getId() + " - " + grado.getNombre() + " - " + grado.getNivel());
            }
        }
        // ===========================================
        
        request.setAttribute("lista", lista);  // <-- ESTO ES CLAVE
        request.getRequestDispatcher("grados.jsp").forward(request, response);
        return;
    }

    switch (accion) {
    case "nuevo":  // <-- AGREGAR ESTE CASO
        System.out.println("Redirigiendo a formulario nuevo");
        request.getRequestDispatcher("gradoForm.jsp").forward(request, response);
        break;
        
    case "editar":
        int idEditar = Integer.parseInt(request.getParameter("id"));
        Grado g = dao.obtenerPorId(idEditar);
        request.setAttribute("grado", g);
        request.getRequestDispatcher("gradoForm.jsp").forward(request, response);
        break;

    case "eliminar":
        int idEliminar = Integer.parseInt(request.getParameter("id"));
        dao.eliminar(idEliminar);
        response.sendRedirect("GradoServlet");
        break;

    default:
        response.sendRedirect("GradoServlet");
}
}
   @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    System.out.println("=== DO POST GradoServlet ===");
    
    HttpSession session = request.getSession();
    String rol = (String) session.getAttribute("rol");
    
    if (!"admin".equals(rol)) {
        response.sendRedirect("acceso_denegado.jsp");
        return;
    }

    // LOG DE PARÁMETROS
    String nombre = request.getParameter("nombre");
    String nivel = request.getParameter("nivel");
    String idParam = request.getParameter("id");
    
    System.out.println("Nombre recibido: " + nombre);
    System.out.println("Nivel recibido: " + nivel);
    System.out.println("ID recibido: " + idParam);

    int id = (idParam != null && !idParam.isEmpty())
            ? Integer.parseInt(idParam) : 0;

    Grado g = new Grado();
    g.setNombre(nombre);
    g.setNivel(nivel);

    System.out.println("Procesando: " + (id == 0 ? "AGREGAR" : "ACTUALIZAR ID=" + id));

    if (id == 0) {
        int resultado = dao.agregar(g);
        System.out.println("Resultado de agregar: ID = " + resultado);
    } else {
        g.setId(id);
        boolean resultado = dao.actualizar(g);
        System.out.println("Resultado de actualizar: " + resultado);
    }

    response.sendRedirect("GradoServlet");
}
}