package dao.intermediate;

import dao.DAO;
import dao.DAOLugar;
import dao.DAOUsuarioRegistrado;
import vos.Lugar;
import vos.UsuarioRegistrado;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by Dave on 20/03/2017.
 */
public class DAOPreferenciaLugar extends DAO
{
	public void createEntryPreferenciaLugar( Long idLugar, Long idUsuario, String tipo ) throws SQLException
	{
		StringBuilder sql = new StringBuilder( );
		sql.append( "INSERT INTO PREFERENCIA_LUGARES " );
		sql.append( "( id_lugar, id_usuario, id_tipo )" );
		sql.append( "VALUES ( " );
		sql.append( String.format( "%s, ", idLugar ) );
		sql.append( String.format( "%s, ", idUsuario ) );
		sql.append( String.format( "'%s' ", tipo ) );
		sql.append( ") " );
		
		PreparedStatement s = connection.prepareStatement( sql.toString( ) );
		s.execute( );
		s.close( );
	}
	
	public List<Lugar> getLugaresPreferidosByUser( Long idUsuario, String tipo ) throws SQLException
	{
		List<Lugar> list = new LinkedList<>( );
		
		StringBuilder sql = new StringBuilder( );
		sql.append( "SELECT * " );
		sql.append( "FROM PREFERENCIA_LUGARES P INNER JOIN LUGARES L " );
		sql.append( "                        ON P.id_lugar = L.id " );
		sql.append( String.format( "WHERE P.id_usuario = %s ", idUsuario ) );
		sql.append( String.format( "  AND P.id_tipo = '%s' ", tipo ) );
		
		PreparedStatement s = connection.prepareStatement( sql.toString( ) );
		ResultSet rs = s.executeQuery( );
		while( rs.next( ) )
		{
			list.add( DAOLugar.restultToAccesibildiad( rs ) );
		}
		rs.close( );
		s.close( );
		return list;
	}
	
	public List<UsuarioRegistrado> getUsersWhoPreferLugar( Long idLugar ) throws SQLException
	{
		List<UsuarioRegistrado> list = new LinkedList<>( );
		
		StringBuilder sql = new StringBuilder( );
		sql.append( "SELECT * " );
		sql.append( "FROM PREFERENCIA_LUGARES P INNER JOIN USUARIOS_REGISTRADOS U " );
		sql.append( "                        ON P.id_usuario = U.identificacion " );
		sql.append( String.format( "WHERE P.id_lugar = %s ", idLugar ) );
		
		PreparedStatement s = connection.prepareStatement( sql.toString( ) );
		ResultSet rs = s.executeQuery( );
		while( rs.next( ) )
		{
			list.add( DAOUsuarioRegistrado.resultToUsuarioRegistrado( rs ) );
		}
		rs.close( );
		s.close( );
		return list;
	}
	
	public Lugar getLugarPreferidoUser( Long idUsuario, String tipo, Long idLugar ) throws SQLException
	{
		Lugar lug = null;
		StringBuilder sql = new StringBuilder( );
		sql.append( "SELECT * " );
		sql.append( "FROM PREFERENCIA_LUGARES P INNER JOIN LUGARES L " );
		sql.append( "                        ON P.id_lugar = L.id " );
		sql.append( String.format( "WHERE P.id_usuario = %s ", idUsuario ) );
		sql.append( String.format( "  AND P.id_tipo = '%s' ", tipo ) );
		sql.append( String.format( "  AND P.id_lugar = %s ", idLugar ) );
		
		PreparedStatement s = connection.prepareStatement( sql.toString( ) );
		ResultSet rs = s.executeQuery( );
		if( rs.next( ) )
		{
			lug = DAOLugar.restultToAccesibildiad( rs );
		}
		rs.close( );
		s.close( );
		return lug;
	}
	
	public void deletePreferenciaLugar( Long idUsuario, String tipo, Long idLugar ) throws SQLException
	{
		StringBuilder sql = new StringBuilder( );
		sql.append( "DELETE FROM PREFERENCIA_LUGARES " );
		sql.append( String.format( "WHERE id_usuario = %s ", idUsuario ) );
		sql.append( String.format( "  AND id_tipo = '%s' ", tipo ) );
		sql.append( String.format( "  AND id_lugar = %s", idLugar ) );
		
		PreparedStatement s = connection.prepareStatement( sql.toString( ) );
		s.execute( );
		s.close( );
	}
}