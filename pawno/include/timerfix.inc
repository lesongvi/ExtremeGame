preventCrash(); public preventCrash()
{
	SetTimerEx("preventCrash", 0, 0, "");
}

stock SetTimerEx_(szFunc[], iInterval, iRepeating, szFormat[], { Float, _ }: ...)
{
	new
		iArgs = numargs() << 2,
		iStart,
		iEnd
	;
	#emit CONST.PRI szFormat
	#emit STOR.S.PRI iStart

	#emit LOAD.S.PRI iArgs
	#emit ADD.C 8
	#emit STOR.S.PRI iEnd

	for(new i = iEnd; i >= iStart; i -= 4)
	{
		#emit LCTRL 5
		#emit LOAD.S.ALT i
		#emit ADD
		#emit LOAD.I
		#emit PUSH.PRI
	}
	#emit PUSH.S szFormat
	#emit PUSH.S iRepeating
	#emit PUSH.S iInterval
	#emit PUSH.S szFunc
	#emit PUSH.S iArgs
	#emit SYSREQ.C SetTimerEx

	for(iArgs = (iArgs >> 2) + 1; iArgs--; )
	{
		#emit STACK 4
	}
}
