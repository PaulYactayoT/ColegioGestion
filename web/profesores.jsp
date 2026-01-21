<%-- 
    Document   : profesores
    Created on : 1 may. 2025, 8:55:51 p.m.
    Author     : Juan Pablo Amaya
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, modelo.Profesor" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null || session.getAttribute("usuario") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    List<Profesor> lista = (List<Profesor>) request.getAttribute("lista");
    
    // Recuperar mensajes de la sesión
    String mensaje = (String) session.getAttribute("mensaje");
    String error = (String) session.getAttribute("error");
    
    // Limpiar mensajes de sesión después de mostrarlos
    if (mensaje != null) {
        session.removeAttribute("mensaje");
    }
    if (error != null) {
        session.removeAttribute("error");
    }
    
    // Formateador de fecha
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Listado de Profesores</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/estilos.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .table th {
            background-color: #343a40;
            color: white;
            vertical-align: middle;
        }
        .badge-activo {
            background-color: #28a745;
            color: white;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 0.8em;
        }
        .badge-inactivo {
            background-color: #dc3545;
            color: white;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 0.8em;
        }
        .actions {
            white-space: nowrap;
        }
    </style>
</head>
<body class="dashboard-page">

    <jsp:include page="header.jsp" />

    <div class="container mt-4">
        <h2 class="mb-4">Listado de Profesores</h2>
        
        <%-- Mostrar mensajes de éxito --%>
        <% if (mensaje != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> <%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <%-- Mostrar mensajes de error --%>
        <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i> <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <div class="mb-3">
            <a href="ProfesorServlet?accion=nuevo" class="btn btn-success">
                <i class="bi bi-person-plus"></i> Registrar Nuevo Profesor
            </a>
        </div>
        
        <%-- Tabla de profesores --%>
        <div class="table-responsive">
            <table class="table table-bordered table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>DNI</th>
                        <th>Nombres</th>
                        <th>Apellidos</th>
                        <th>Correo</th>
                        <th>Teléfono</th>
                        <th>Especialidad</th>
                        <th>Estado</th>
                        <th>Fecha Registro</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (lista != null && !lista.isEmpty()) {
                            int contador = 1;
                            for (Profesor p : lista) {
                                String estadoClass = "ACTIVO".equals(p.getEstado()) ? "badge-activo" : "badge-inactivo";
                    %>
                    <tr>
                        <td><%= contador %></td>
                        <td><%= p.getDni() != null ? p.getDni() : "N/A" %></td>
                        <td><%= p.getNombres() %></td>
                        <td><%= p.getApellidos() %></td>
                        <td><%= p.getCorreo() %></td>
                        <td><%= p.getTelefono() != null ? p.getTelefono() : "N/A" %></td>
                        <td><%= p.getEspecialidad() %></td>
                        <td>
                            <span class="<%= estadoClass %>">
                                <%= p.getEstado() != null ? p.getEstado() : "ACTIVO" %>
                            </span>
                        </td>
                        <td>
                            <%
                                if (p.getFechaRegistro() != null) {
                                    out.print(sdf.format(p.getFechaRegistro()));
                                } else {
                                    out.print("N/A");
                                }
                            %>
                        </td>
                        <td class="actions">
                            <%-- Botón Editar --%>
                            <a href="ProfesorServlet?accion=editar&id=<%= p.getId() %>" 
                               class="btn btn-warning btn-sm" title="Editar">
                                <i class="bi bi-pencil"></i> Editar
                            </a>

                            <%-- Botón Eliminar --%>
                            <a href="ProfesorServlet?accion=eliminar&id=<%= p.getId() %>" 
                               class="btn btn-danger btn-sm" 
                               title="Eliminar"
                               onclick="return confirm('¿Está seguro de eliminar al profesor <%= p.getNombres() %> <%= p.getApellidos() %>? (ID: <%= p.getId() %>)')">
                                <i class="bi bi-trash"></i> Eliminar
                            </a>
                        </td>
                    <%
                                contador++;
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="10" class="text-center text-muted py-4">
                            <i class="bi bi-people display-4"></i><br>
                            No hay profesores registrados.
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        
        <%-- Estadísticas --%>
        <div class="mt-3">
            <small class="text-muted">
                <i class="bi bi-info-circle"></i>
                Total de profesores: <%= lista != null ? lista.size() : 0 %>
                <% 
                    if (lista != null) {
                        int activos = 0;
                        for (Profesor p : lista) {
                            if ("ACTIVO".equals(p.getEstado())) {
                                activos++;
                            }
                        }
                        out.print(" | Activos: " + activos);
                    }
                %>
            </small>
        </div>
    </div>
    
    <%-- Footer --%>
    <footer class="bg-dark text-white py-2 mt-4">
        <div class="container text-center text-md-start">
            <div class="row">
                <div class="col-md-4 mb-0">
                    <div class="logo-container text-center">
                        <img src="assets/img/logosa.png" alt="Logo" class="img-fluid mb-1" width="80" height="auto">
                        <p class="fs-6">"Líderes en educación de calidad al más alto nivel"</p>
                    </div>
                </div>
                <div class="col-md-4 mb-0">
                    <h5 class="fs-8">Contacto:</h5>
                    <p class="fs-6">Dirección: Av. El Sol 461, San Juan de Lurigancho 15434</p>
                    <p class="fs-6">Teléfono: 987654321</p>
                    <p class="fs-6">Correo: colegiosanantonio@gmail.com</p>
                </div>
                <div class="col-md-4 mb-0">
                    <h5 class="fs-8">Síguenos:</h5>
                    <a href="https://www.facebook.com/" class="text-white d-block fs-6">Facebook</a>
                    <a href="https://www.instagram.com/" class="text-white d-block fs-6">Instagram</a>
                    <a href="https://twitter.com/" class="text-white d-block fs-6">Twitter</a>
                    <a href="https://www.youtube.com/" class="text-white d-block fs-6">YouTube</a>
                </div>
            </div>
            <div class="text-center mt-0">
                <p class="fs-6">&copy; 2025 Colegio SA - Todos los derechos reservados</p>
            </div>
        </div>
    </footer>
    
    <%-- Bootstrap JS --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto cerrar alertas después de 5 segundos
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
    
</body>
</html>
