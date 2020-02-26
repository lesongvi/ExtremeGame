/*
 *					  v1.0
 *      			Firewerkz
 *
 *      		Created all by Lorenc_
 *
 *		www.irresistiblegaming.com - Where gaming is irresistible!
*/

/* ** Includes ** */
#include 							< a_samp >
#include 							< streamer >

/* ** TOGGLE ** */
#define NEON_MODE					false // Pretty ugly if it is toggled... The lights are not synced well.
#define EXPLOSION_DELAY				320 // This delays each explosion :P
#define MAX_PROJECTILES				( 25 )

/* ** Functions ** */
#define fw::RandomEx(%0,%1)  		(random((%1) - (%0)) + (%0))

/* ** Variables ** */
enum E_FIREWORK_DATA
{
	bool: E_PLACED,			E_OBJECT_ID,			E_PROJECTILE[ MAX_PROJECTILES ]
}
	
static stock
	g_fireWorkData					[ 10 ] [ E_FIREWORK_DATA ],
	
	bool: FW_ODOM
;

/* ** Script ** */
forward fw_DestroyProjectile( id, pid );
forward fw_SetToExplode( Float: X, Float: Y, Float: Z );

stock CreateFirework( Float: X, Float: Y, Float: Z, Float: speed = 9.0, Float: height = 20.0 )
{
	new 
		id;
		
	for( id = 0; id < sizeof( g_fireWorkData ); ++id )
		if( !g_fireWorkData[ id ] [ E_PLACED ] ) break;
		
	if( id >= sizeof( g_fireWorkData ) )
		return -1;
	
	if( g_fireWorkData[ id ] [ E_PLACED ] ) 
		return -1;
		
	g_fireWorkData[ id ] [ E_PLACED ] = true;
	g_fireWorkData[ id ] [ E_OBJECT_ID ] = CreateDynamicObject( 345, X, Y, Z, 90.0, 0.0, 0.0 );
	MoveDynamicObject( g_fireWorkData[ id ] [ E_OBJECT_ID ], X, Y, Z + height, speed );
	return id;
}

public OnDynamicObjectMoved( objectid )
{
	for( new id = 0; id < sizeof( g_fireWorkData ); id++ )
	{
		if( g_fireWorkData[ id ] [ E_OBJECT_ID ] == objectid )
		{		
			new 
				Float: X, Float: Y, Float: Z
			;
			GetDynamicObjectPos( objectid, X, Y, Z );
			for( new x = 0, Float: degree = 0.0; x < MAX_PROJECTILES; x++ )
			{
				degree += ( 360 / MAX_PROJECTILES );
				
				#if NEON_MODE == true
					g_fireWorkData[ id ] [ E_PROJECTILE ] [ x ] = CreateDynamicObject( fw::RandomEx( 18647, 18652 ), X, Y, Z, 0.0, 0.0, degree );
					X += 2.0 * floatsin( degree, degrees );
					Y += 2.0 * floatcos( degree, degrees );
					Z += 2.0 * floattan( degree, degrees );
					MoveDynamicObject( g_fireWorkData[ id ] [ E_PROJECTILE ] [ x ], X, Y, Z, 5.0 );
					SetTimerEx( "fw_DestroyProjectile", 6000, false, "dd", id, x );
				#else
					X += random( 10 ) * floatsin( degree, degrees );
					Y += random( 10 ) * floatcos( degree, degrees );
					Z += random( 5 ) * floattan( degree, degrees );
					SetTimerEx( "fw_SetToExplode", x * EXPLOSION_DELAY, false, "fff", X, Y, Z );
				#endif
			}
			g_fireWorkData[ id ] [ E_PLACED ] = false;
			DestroyDynamicObject( g_fireWorkData[ id ] [ E_OBJECT_ID ] );
			g_fireWorkData[ id ] [ E_OBJECT_ID ] = INVALID_OBJECT_ID;	
			break;
		}
	}
	return ( FW_ODOM ) ? CallLocalFunction( "FW_OnDynamicObjectMoved", "d", objectid ) : 1;
}

public fw_SetToExplode( Float: X, Float: Y, Float: Z )
	return CreateExplosion( X, Y, Z, 10, 0.0 );

public fw_DestroyProjectile( id, pid )
{
	DestroyDynamicObject( g_fireWorkData[ id ] [ E_PROJECTILE ] [ pid ] );
	g_fireWorkData[ id ] [ E_PROJECTILE ] [ pid ] = INVALID_OBJECT_ID;
	return 1;
}

#if defined _ALS_OnDynamicObjectMoved
	#undef OnDynamicObjectMoved
#else
	#define _ALS_OnDynamicObjectMoved
#endif
#define OnDynamicObjectMoved FW_OnDynamicObjectMoved
forward FW_OnDynamicObjectMoved( objectid );
	

#if !defined FILTERSCRIPT
	public OnGameModeInit()
	{
		FW_ODOM = ( funcidx( "FW_OnDynamicObjectMoved" ) != -1 );
		return ( funcidx( "FW_OnGameModeInit" ) != -1 ) ? CallLocalFunction( "FW_OnGameModeInit", "" ) : 1;
	}	
	#if defined _ALS_OnGameModeInit
		#undef OnGameModeInit
	#else
		#define _ALS_OnGameModeInit
	#endif
	#define OnGameModeInit FW_OnGameModeInit
	forward FW_OnGameModeInit();
#else
	public OnFilterScriptInit()
	{
		FW_ODOM = ( funcidx( "FW_OnDynamicObjectMoved" ) != -1 );
		return ( funcidx( "FW_OnFilterScriptInit" ) != -1 ) ? CallLocalFunction( "FW_OnFilterScriptInit", "" ) : 1;
	}	
	#if defined _ALS_OnFilterScriptInit
		#undef OnFilterScriptInit
	#else
		#define _ALS_OnFilterScriptInit
	#endif
	#define OnFilterScriptInit FW_OnFilterScriptInit
	forward FW_OnFilterScriptInit();
#endif