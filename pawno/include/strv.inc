
forward CheckString(string[]);
public CheckString(string[])
{
	for(new i = 0; i < strlen(string); i++)
	{
		if(!IsALetter(string[i]))
		return 0;
	}
	return 1;
}


stock IsALetter(string)
{
	if(string == 'q') return 1;
	else if(string == 'Q') return 1;
	else if(string == 'w') return 1;
	else if(string == 'W') return 1;
	else if(string == 'e') return 1;
	else if(string == 'E') return 1;
	else if(string == 'R') return 1;
	else if(string == 'r') return 1;
	else if(string == 't') return 1;
	else if(string == 'T') return 1;
	else if(string == 'y') return 1;
	else if(string == 'Y') return 1;
	else if(string == 'u') return 1;
	else if(string == 'U') return 1;
	else if(string == 'i') return 1;
	else if(string == 'I') return 1;
	else if(string == 'o') return 1;
	else if(string == 'O') return 1;
	else if(string == 'P') return 1;
	else if(string == 'p') return 1;
	else if(string == 'A') return 1;
	else if(string == 'a') return 1;
	else if(string == 'S') return 1;
	else if(string == 's') return 1;
	else if(string == 'D') return 1;
	else if(string == 'd') return 1;
	else if(string == 'F') return 1;
	else if(string == 'f') return 1;
	else if(string == 'G') return 1;
	else if(string == 'g') return 1;
	else if(string == 'H') return 1;
	else if(string == 'h') return 1;
	else if(string == 'J') return 1;
	else if(string == 'j') return 1;
	else if(string == 'k') return 1;
	else if(string == 'K') return 1;
	else if(string == 'l') return 1;
	else if(string == 'L') return 1;
	else if(string == 'z') return 1;
	else if(string == 'Z') return 1;
	else if(string == 'X') return 1;
	else if(string == 'x') return 1;
	else if(string == 'C') return 1;
	else if(string == 'c') return 1;
	else if(string == 'V') return 1;
	else if(string == 'v') return 1;
	else if(string == 'b') return 1;
	else if(string == 'B') return 1;
	else if(string == 'N') return 1;
	else if(string == 'n') return 1;
	else if(string == 'M') return 1;
	else if(string == 'm') return 1;
	else if(string == '0') return 1;
	else if(string == '1') return 1;
	else if(string == '2') return 1;
	else if(string == '3') return 1;
	else if(string == '4') return 1;
	else if(string == '5') return 1;
	else if(string == '6') return 1;
	else if(string == '7') return 1;
	else if(string == '8') return 1;
	else if(string == '9') return 1;
	else return 0;
}
