package rest;

import java.sql.SQLException;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Response;

import tm.RequerimientoTecnicoTM;
import vos.RequerimientoTecnico;

@Path("requerimientos")
public class RequerimientoTecnicoServices extends Services{
	@POST
	public Response createRequerimientoTecnico( RequerimientoTecnico requerimientoTecnico )
	{
		RequerimientoTecnicoTM tm = new RequerimientoTecnicoTM( getPath( ) );
		try
		{
			requerimientoTecnico = tm.createRequerimientoTecnico( requerimientoTecnico );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( requerimientoTecnico ).build( );
	}
	
	@GET
	public Response getRequerimientoTecnico( )
	{
		List<RequerimientoTecnico> list;
		RequerimientoTecnicoTM tm = new RequerimientoTecnicoTM( getPath( ) );
		try
		{
			list = tm.getRequerimientosTecnicos( );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( list ).build( );
	}
	
	@GET
	@Path( "{id}" )
	public Response getRequerimientoTecnico( @PathParam( "id" ) Long id )
	{
		RequerimientoTecnico req;
		RequerimientoTecnicoTM tm = new RequerimientoTecnicoTM( getPath( ) );
		try
		{
			req = tm.getRequerimientoTecnico( id );
		}
		catch( SQLException e )
		{
			return Response.status( 500 ).entity( doErrorMessage( e ) ).build( );
		}
		return Response.status( 200 ).entity( req ).build( );
	}
}