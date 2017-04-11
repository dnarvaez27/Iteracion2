package rest;

import tm.FuncionCM;
import tm.intermediate.CostoLocalidadTM;
import utilities.DateUtils;
import vos.Funcion;
import vos.Localidad;
import vos.intermediate.CostoLocalidad;
import vos.reportes.RFC3;

import javax.servlet.ServletContext;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

@Path( "funciones" )
@Produces( { MediaType.APPLICATION_JSON } )
@Consumes( { MediaType.APPLICATION_JSON } )
public class FuncionServices extends Services
{
	public FuncionServices( )
	{
	}
	
	public FuncionServices( ServletContext context )
	{
		super( context );
	}
	
	@POST
	public Response createFuncion( Funcion funcion,
	                               @HeaderParam( "id" ) Long id,
	                               @HeaderParam( "tipo" ) String tipo,
	                               @HeaderParam( "password" ) String password, @PathParam( "idEspectaculo" ) Long idEspectaculo )
	{
		FuncionCM tm = new FuncionCM( getPath( ) );
		try
		{
			funcion.setIdEspectaculo( idEspectaculo );
			funcion = tm.createFuncion( id, tipo, password, funcion );
		}
		catch( Exception e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( funcion ).build( );
	}
	
	@GET
	public Response getFunciones( @PathParam( "idEspectaculo" ) Long idEspectaculo )
	{
		List<Funcion> list;
		FuncionCM tm = new FuncionCM( getPath( ) );
		try
		{
			list = tm.getFuncionesFrom( idEspectaculo );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( list ).build( );
	}
	
	@GET
	@Path( "all" )
	public Response getFunciones( )
	{
		List<Funcion> list;
		FuncionCM tm = new FuncionCM( getPath( ) );
		try
		{
			list = tm.getFunciones( );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( list ).build( );
	}
	
	@GET
	@Path( "{lugar}/{fecha}" )
	public Response getFuncion( @PathParam( "lugar" ) Long idFecha, @PathParam( "fecha" ) String fecha )
	{
		Funcion funcion;
		FuncionCM tm = new FuncionCM( getPath( ) );
		try
		{
			funcion = tm.getFuncion( DateUtils.format( fecha ), idFecha );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( funcion ).build( );
	}
	
	@PUT
	@Path( "{lugar}/{fecha}" )
	public Response updateFuncion(
			@HeaderParam( "idUsuario" ) Long idUsuario,
			@HeaderParam( "tipo" ) String tipoId,
			@HeaderParam( "password" ) String password, @PathParam( "lugar" ) Long idFecha, @PathParam( "fecha" ) String fecha, Funcion funcion )
	{
		FuncionCM tm = new FuncionCM( getPath( ) );
		try
		{
			funcion = tm.updateFuncion( idUsuario, tipoId, password, DateUtils.format( fecha ), idFecha, funcion );
		}
		catch( Exception e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( funcion ).build( );
	}
	
	@DELETE
	@Path( "{lugar}/{fecha}" )
	public Response deleteFuncion( @PathParam( "lugar" ) Long idLugar, @PathParam( "fecha" ) String fecha )
	{
		FuncionCM tm = new FuncionCM( getPath( ) );
		try
		{
			tm.deleteFuncion( DateUtils.format( fecha ), idLugar );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).build( );
	}
	
	// LOCALIDADES
	@POST
	@Path( "{id_lugar}/{fecha_funcion}/localidades" )
	public Response createEntryCostoLocalidad(
			@PathParam( "id_lugar" ) Long idLugar, @PathParam( "fecha_funcion" ) String fechaFuncion, CostoLocalidad costoLocalidad )
	{
		costoLocalidad.setIdLugar( idLugar );
		costoLocalidad.setFecha( DateUtils.format( fechaFuncion ) );
		
		CostoLocalidadTM tm = new CostoLocalidadTM( getPath( ) );
		try
		{
			costoLocalidad = tm.createCostoLocalidad( costoLocalidad );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( costoLocalidad ).build( );
	}
	
	@GET
	@Path( "{id_lugar}/{fecha_funcion}/localidades" )
	public Response getCostoLocalidadesFrom( @PathParam( "id_lugar" ) Long idLugar, @PathParam( "fecha_funcion" ) String fechaFuncion )
	{
		List<Localidad> list;
		CostoLocalidadTM tm = new CostoLocalidadTM( getPath( ) );
		try
		{
			list = tm.getCostoLocalidadesFromFuncion( DateUtils.format( fechaFuncion ), idLugar );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( list ).build( );
	}
	
	@GET
	@Path( "{id_lugar}/{fecha_funcion}/localidades/{id_localidad}" )
	public Response getCostoLocalidadFrom(
			@PathParam( "id_lugar" ) Long idLugar, @PathParam( "fecha_funcion" ) String fechaFuncion, @PathParam( "id_localidad" ) Long idLocalidad )
	{
		Localidad costoLocalidad;
		CostoLocalidadTM tm = new CostoLocalidadTM( getPath( ) );
		try
		{
			costoLocalidad = tm.getCostoLocalidadFrom( DateUtils.format( fechaFuncion ), idLugar, idLocalidad );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( costoLocalidad ).build( );
	}
	
	@PUT
	@Path( "{id_Lugar}/{fecha_funcion}/localidades/{id_localidad}" )
	public Response updateCostoLocalidad( CostoLocalidad costoLocalidad,
	                                      @PathParam( "id_Lugar" ) Long idLugar,
	                                      @PathParam( "fecha_funcion" ) String fecha, @PathParam( "id_localidad" ) Long idLocalidad )
	{
		CostoLocalidadTM tm = new CostoLocalidadTM( getPath( ) );
		try
		{
			costoLocalidad = tm.updateCostoLocalidad( DateUtils.format( fecha ), idLugar, idLocalidad, costoLocalidad );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( costoLocalidad ).build( );
	}
	
	// REPORTES
	
	@GET
	@Path( "src" )
	public Response generarReporte1(
			@QueryParam( "genero" ) String nombreGenero,
			@QueryParam( "compania" ) String nombreCompania,
			@QueryParam( "ciudad" ) String ciudad,
			@QueryParam( "pais" ) String pais,
			@QueryParam( "espectaculo" ) String nombreEspectaculo,
			@QueryParam( "idioma" ) String idioma,
			@QueryParam( "fecha_inicio" ) String fechaInicio,
			@QueryParam( "fecha_fin" ) String fechaFin,
			@QueryParam( "duracion_inicio" ) Integer duracionInicio,
			@QueryParam( "duracion_fin" ) Integer duracionFin,
			@QueryParam( "lugar" ) String lugar,
			@QueryParam( "accesibilidad" ) String accesoEspecial,
			@QueryParam( "clasificacion" ) String publicoObjetivo, @QueryParam( "orderBy" ) List<String> order, @QueryParam( "asc" ) Integer asc )
	{
		List<Funcion> list;
		FuncionCM tm = new FuncionCM( getPath( ) );
		
		try
		{
			list = tm.generarReporte1( nombreGenero, nombreCompania, ciudad, pais, nombreEspectaculo, idioma, fechaInicio, fechaFin, duracionInicio, duracionFin, lugar, accesoEspecial, publicoObjetivo, order, asc == null || asc == 1 );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( list ).build( );
	}
	
	@GET
	@Path( "{lugar}/{fecha}/rfc3" )
	public Response generarReporte3( @PathParam( "lugar" ) Long idLugar, @PathParam( "fecha" ) String fecha )
	{
		RFC3 rfc3;
		FuncionCM tm = new FuncionCM( getPath( ) );
		
		try
		{
			rfc3 = tm.generarReporte3( DateUtils.format( fecha ), idLugar );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( rfc3 ).build( );
	}
	@PUT
	@Path("{lugar}/{fecha}/cancelar")
	public Response cancelarFuncion(@PathParam( "lugar" ) Long idLugar, @PathParam( "fecha" ) String fecha, @HeaderParam("id") Long id, @HeaderParam("tipo") String tipo, @HeaderParam("password") String password)
	{
		FuncionCM tm = new FuncionCM(getPath());
		Double d;
		try{
			Date laFecha = DateUtils.format(fecha);
			d = tm.cancelarFuncion(id, tipo, password, laFecha, idLugar);
			if(d == -1)
				return Response.status( 403 ).build( );
		}
		catch(Exception e)
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status(200).entity(d).build();
	}
}