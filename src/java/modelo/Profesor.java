package modelo;

import java.sql.Date;
import java.sql.Timestamp;

public class Profesor {
    private int id;
    private int personaId;
    private String nombres;
    private String apellidos;
    private String correo;
    private String dni;           // NUEVO
    private String telefono;      // NUEVO
    private String especialidad;
    private String codigoProfesor;
    private String estado;
    private Date fechaContratacion;    // NUEVO
    private Timestamp fechaRegistro;   // NUEVO
    private String direccion;          // NUEVO (opcional)

    // Getters y Setters existentes
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getPersonaId() { return personaId; }
    public void setPersonaId(int personaId) { this.personaId = personaId; }

    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }

    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getEspecialidad() { return especialidad; }
    public void setEspecialidad(String especialidad) { this.especialidad = especialidad; }
    
    public String getCodigoProfesor() { return codigoProfesor; }
    public void setCodigoProfesor(String codigoProfesor) { this.codigoProfesor = codigoProfesor; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    // NUEVOS Getters y Setters
    public String getDni() { return dni; }
    public void setDni(String dni) { this.dni = dni; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public Date getFechaContratacion() { return fechaContratacion; }
    public void setFechaContratacion(Date fechaContratacion) { this.fechaContratacion = fechaContratacion; }

    public Timestamp getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(Timestamp fechaRegistro) { this.fechaRegistro = fechaRegistro; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    // Método toString para debugging
    @Override
    public String toString() {
        return "Profesor{" +
                "id=" + id +
                ", personaId=" + personaId +
                ", nombres='" + nombres + '\'' +
                ", apellidos='" + apellidos + '\'' +
                ", correo='" + correo + '\'' +
                ", dni='" + dni + '\'' +
                ", telefono='" + telefono + '\'' +
                ", especialidad='" + especialidad + '\'' +
                ", codigoProfesor='" + codigoProfesor + '\'' +
                ", estado='" + estado + '\'' +
                ", fechaContratacion=" + fechaContratacion +
                ", fechaRegistro=" + fechaRegistro +
                '}';
    }
}