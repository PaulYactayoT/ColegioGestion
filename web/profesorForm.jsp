<%-- 
    Document   : profesorForm
    Created on : 1 may. 2025, 8:57:32 p. m.
    Author     : Juan Pablo Amaya
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="modelo.Profesor" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session == null || session.getAttribute("usuario") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    Profesor p = (Profesor) request.getAttribute("profesor");
    boolean editar = (p != null);
%>

<head>
    <meta charset="UTF-8">
    <title>Registrar Alumno</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/estilos.css">
</head>
<body class="dashboard-page">

    <jsp:include page="header.jsp" />

    <div class="container">
        <h2 class="mb-4"><%= editar ? "Editar Profesor" : "Registrar Profesor"%></h2>

        <form action="ProfesorServlet" method="POST">
    <input type="hidden" name="id" value="<%= p != null ? p.getId() : "" %>">
    
    <div class="mb-3">
        <label class="form-label">Nombres:</label>
        <input type="text" class="form-control" name="nombres" 
               value="<%= p != null ? p.getNombres() : "" %>" required>
    </div>
    
    <div class="mb-3">
        <label class="form-label">Apellidos:</label>
        <input type="text" class="form-control" name="apellidos" 
               value="<%= p != null ? p.getApellidos() : "" %>" required>
    </div>
    
    <div class="mb-3">
        <label class="form-label">Correo:</label>
        <input type="email" class="form-control" name="correo" 
               value="<%= p != null ? p.getCorreo() : "" %>" required>
    </div>
    
    <div class="mb-3">
        <label class="form-label">Especialidad:</label>
        <input type="text" class="form-control" name="especialidad" 
               value="<%= p != null ? p.getEspecialidad() : "" %>" required>
    </div>
    
    <div class="mb-3">
        <label class="form-label">DNI:</label>
        <input type="text" class="form-control" name="dni" 
               value="<%= p != null ? p.getDni() : "" %>">
    </div>
    
    <div class="mb-3">
        <label class="form-label">Teléfono:</label>
        <input type="text" class="form-control" name="telefono" 
               value="<%= p != null ? p.getTelefono() : "" %>">
    </div>
    
    <button type="submit" class="btn btn-primary">Guardar</button>
    <a href="ProfesorServlet" class="btn btn-secondary">Cancelar</a>
</form>
    </div>
    <footer class="bg-dark text-white py-2">
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
</body>
