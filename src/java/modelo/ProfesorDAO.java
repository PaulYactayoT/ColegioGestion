/*
 * DAO PARA GESTION DE PROFESORES
 * 
 * Funcionalidades:
 * - CRUD completo de profesores
 * - Consulta por credenciales de usuario
 * - Integracion con sistema de autenticacion
 */
package modelo;

import conexion.Conexion;
import java.sql.*;
import java.util.*;

public class ProfesorDAO {

    /**
     * OBTENER PROFESOR POR NOMBRE DE USUARIO
     * 
     * @param username Nombre de usuario del profesor
     * @return Objeto Profesor con datos completos o null si no existe
     */
    public Profesor obtenerPorUsername(String username) {
        System.out.println("[ProfesorDAO] Buscando profesor para username: " + username);
        
        Profesor profesor = null;
        String sql = "{CALL obtener_profesor_por_username(?)}";

        try (Connection con = Conexion.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            
            cs.setString(1, username);
            ResultSet rs = cs.executeQuery();

            if (rs.next()) {
                profesor = mapearProfesor(rs);
                System.out.println("[ProfesorDAO] Profesor encontrado: " + profesor.getNombres() + " " + profesor.getApellidos() + " (ID: " + profesor.getId() + ")");
            } else {
                System.out.println("[ProfesorDAO] No se encontro profesor para username: " + username);
            }

        } catch (Exception e) {
            System.out.println("[ProfesorDAO] Error al buscar profesor por username: " + e.getMessage());
            e.printStackTrace();
        }

        return profesor;
    }

    /**
     * LISTAR TODOS LOS PROFESORES
     * 
     * @return Lista completa de profesores registrados
     */
   public List<Profesor> listar() {
    List<Profesor> lista = new ArrayList<>();
    String sql = "{CALL obtener_profesores_completos()}";
    
    System.out.println("=== DEBUG listar profesores ===");
    System.out.println("SQL: " + sql);
    
    try (Connection con = Conexion.getConnection();
         CallableStatement cs = con.prepareCall(sql);
         ResultSet rs = cs.executeQuery()) {
        
        System.out.println("Conexión establecida: " + (con != null));
        
        int contador = 0;
        while (rs.next()) {
            contador++;
            Profesor p = new Profesor();
            p.setId(rs.getInt("profesor_id"));
            p.setPersonaId(rs.getInt("persona_id"));
            p.setNombres(rs.getString("nombres"));
            p.setApellidos(rs.getString("apellidos"));
            p.setCorreo(rs.getString("correo"));
            p.setDni(rs.getString("dni"));  // AÑADIDO
            p.setTelefono(rs.getString("telefono")); // AÑADIDO si no existe, agrégalo al modelo
            p.setEspecialidad(rs.getString("especialidad"));
            p.setCodigoProfesor(rs.getString("codigo_profesor"));
            p.setEstado(rs.getString("estado"));
            p.setFechaRegistro(rs.getTimestamp("fecha_registro")); // AÑADIDO
            p.setFechaContratacion(rs.getDate("fecha_contratacion")); // AÑADIDO
            
            System.out.println("Profesor " + contador + ": " + p.getNombres() + " " + p.getApellidos() + " DNI: " + p.getDni());
            lista.add(p);
        }
        
        System.out.println("Total profesores encontrados: " + contador);
        
    } catch (SQLException e) {
        System.err.println("ERROR en listar profesores: " + e.getMessage());
        e.printStackTrace();
    }
    
    return lista;
}

    /**
     * AGREGAR NUEVO PROFESOR
     * 
     * @param p Objeto Profesor con datos del nuevo profesor
     * @return true si el registro fue exitoso
     */
  public boolean agregar(Profesor p) {
    String sql = "{CALL crear_profesor_completo(?, ?, ?, ?, ?, ?)}";
    
    System.out.println("=== DEBUG agregar profesor ===");
    System.out.println("Nombres: " + p.getNombres());
    System.out.println("Apellidos: " + p.getApellidos());
    System.out.println("Correo: " + p.getCorreo());
    System.out.println("DNI: " + p.getDni()); // Agregado
    System.out.println("Teléfono: " + p.getTelefono()); // Agregado
    System.out.println("Especialidad: " + p.getEspecialidad());
    
    try (Connection con = Conexion.getConnection();
         CallableStatement cs = con.prepareCall(sql)) {
        
        cs.setString(1, p.getNombres());
        cs.setString(2, p.getApellidos());
        cs.setString(3, p.getCorreo());
        cs.setString(4, p.getDni()); // Enviar DNI
        cs.setString(5, p.getTelefono()); // Enviar teléfono
        cs.setString(6, p.getEspecialidad());
        
        ResultSet rs = cs.executeQuery();
        if (rs.next()) {
            int id = rs.getInt("id");
            p.setId(id);
            System.out.println("Profesor creado con ID: " + id);
            return true;
        }
        return false;
        
    } catch (SQLException e) {
        System.err.println("ERROR en agregar profesor: " + e.getMessage());
        System.err.println("SQLState: " + e.getSQLState());
        System.err.println("Error Code: " + e.getErrorCode());
        e.printStackTrace();
        return false;
    }
}

    /**
     * OBTENER PROFESOR POR ID
     * 
     * @param id Identificador unico del profesor
     * @return Objeto Profesor o null si no existe
     */
   public Profesor obtenerPorId(int id) {
    System.out.println("=== DEBUG obtenerPorId ===");
    System.out.println("Buscando profesor con ID: " + id);
    
    Profesor p = null;
    String sql = "{CALL obtener_profesor_por_id(?)}";

    try (Connection con = Conexion.getConnection();
         CallableStatement cs = con.prepareCall(sql)) {
        
        cs.setInt(1, id);
        System.out.println("SQL: " + sql);
        
        ResultSet rs = cs.executeQuery();

        if (rs.next()) {
            System.out.println("Profesor ENCONTRADO en BD");
            p = mapearProfesor(rs);
            System.out.println("ID mapeado: " + p.getId());
            System.out.println("Nombre: " + p.getNombres());
        } else {
            System.out.println("Profesor NO encontrado en BD para ID: " + id);
        }

    } catch (Exception e) {
        System.out.println("ERROR en obtenerPorId: " + e.getMessage());
        e.printStackTrace();
    }
    
    System.out.println("Resultado: " + (p != null ? "OK" : "NULL"));
    return p;
}

    /**
     * ACTUALIZAR DATOS DE PROFESOR EXISTENTE
     * 
     * @param p Objeto Profesor con datos actualizados
     * @return true si la actualizacion fue exitosa
     */
    public boolean actualizar(Profesor p) {
        String sql = "{CALL actualizar_profesor(?, ?, ?, ?, ?)}";

        try (Connection con = Conexion.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, p.getId());
            cs.setString(2, p.getNombres());
            cs.setString(3, p.getApellidos());
            cs.setString(4, p.getCorreo());
            cs.setString(5, p.getEspecialidad());
            
            int resultado = cs.executeUpdate();
            System.out.println("Profesor actualizado: " + p.getNombres() + " " + p.getApellidos());
            return resultado > 0;

        } catch (Exception e) {
            System.out.println("Error al actualizar profesor: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ELIMINAR PROFESOR POR ID
     * 
     * @param id Identificador del profesor a eliminar
     * @return true si la eliminacion fue exitosa
     */
  public boolean eliminar(int id) {
    String sql = "{CALL eliminar_profesor(?)}";
    
    System.out.println("=== DEBUG eliminar profesor ===");
    System.out.println("ID a eliminar: " + id);
    
    try (Connection con = Conexion.getConnection();
         CallableStatement cs = con.prepareCall(sql)) {

        cs.setInt(1, id);
        // IMPORTANTE: Cambia esto según lo que devuelva tu procedimiento
        int filasAfectadas = cs.executeUpdate(); // Si el SP usa UPDATE/DELETE
        // O si devuelve un número:
        // ResultSet rs = cs.executeQuery();
        // if (rs.next()) { return rs.getInt(1) > 0; }
        
        System.out.println("Filas afectadas: " + filasAfectadas);
        return filasAfectadas > 0;

    } catch (Exception e) {
        System.err.println("ERROR SQL al eliminar profesor ID " + id + ": ");
        e.printStackTrace();
        return false;
    }
}

    /**
     * METODO AUXILIAR PARA MAPEAR RESULTADO DE CONSULTA A OBJETO PROFESOR
     * 
     * @param rs ResultSet con datos de la base de datos
     * @return Objeto Profesor mapeado
     * @throws SQLException Si hay error en el acceso a datos
     */
    private Profesor mapearProfesor(ResultSet rs) throws SQLException {
        Profesor p = new Profesor();
        p.setId(rs.getInt("id"));
        p.setNombres(rs.getString("nombres"));
        p.setApellidos(rs.getString("apellidos"));
        p.setCorreo(rs.getString("correo"));
        p.setEspecialidad(rs.getString("especialidad"));
        return p;
    }
}