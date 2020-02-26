#include <a_samp>
#include <DOF2>
#include <streamer>

#define MAX_GARAGENS 200 // MAXIMUM OF GARAGES
#define MAX_CARS 1 // MAXIMUM CAR GARAGE BY +1
#define COORDENADASGARAGEM -1232.7811279297,-74.612930297852,14.502492904663 // X,Y,Z THE GARAGE (DO NOT PUT SPACES BETWEEN COORDINATES)
#define COR_ERRO 0xAD0000AA
#define COR_SUCESSO 0x00AB00AA

forward CarregarGaragens();
forward SalvarGaragens();
forward CreateGarage(playerowner[64], garageid, Float:gx, Float:gy, Float:gz, coment[128], bool:lock);
forward DeletarGaragem(garageid);
forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
forward GarageToPoint(Float:radi, garageid, Float:x, Float:y, Float:z);
forward FecharGaragem(playerid, garageid);
forward AbrirGaragem(playerid, garageid);
forward SetGaragemComent(garageid, coment[128]);
forward SetGaragemDono(garageid, playerowner[64]);
forward SetGaragemPos(garageid, Float:gx, Float:gy, Float:gz);
forward Creditos();

enum pGaragem
{
	Float:cnX,
	Float:cnY,
	Float:cnZ,
	cnLock,
	cnCar,
}

new Garagem[MAX_GARAGENS][pGaragem];
new Text3D:LabelEntrada[MAX_GARAGENS];
new Text3D:LabelSaida[MAX_GARAGENS];
new LabelString[MAX_GARAGENS][128];
new NameString[MAX_GARAGENS][64];
new GaragemAtual;
new EditandoGaragem[MAX_PLAYERS];
new bool:Deletado[MAX_GARAGENS];

public OnFilterScriptInit()
{
 	print("\n--------------------------------------");
	print("         Garage-Sistem by Roby pawno.ro ¬¬");
	print("--------------------------------------\n");
	CarregarGaragens();
	SetTimer("Creditos", 1000*1*60*15, true);
	new cobj0 = CreateDynamicObject(19451, 1931.082642, 1344.845947, 128.956207, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj0, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj1 = CreateDynamicObject(19464, 1929.720337, 1346.156860, 131.005203, 0.000000, -1.099900, 90.300003);
	SetDynamicObjectMaterial(cobj1, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj2 = CreateDynamicObject(19451, 1927.599243, 1344.851318, 128.908203, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj2, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(19305, 1927.392456, 1346.058960, 130.696106, 0.999800, 0.999800, 0.299800);
	new cobj3 = CreateDynamicObject(19464, 1932.713745, 1343.254761, 131.029907, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj3, 0, 18031, "cj_exp", "mp_cloth_wall");
	CreateObject(18757, 1929.832153, 1348.008423, 130.920502, 0.000000, 0.000000, 89.599800);
	new cobj4 = CreateDynamicObject(19464, 1926.939819, 1343.191650, 131.010803, 0.000000, 0.500100, -179.300003);
	SetDynamicObjectMaterial(cobj4, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj5 = CreateDynamicObject(19464, 1927.845825, 1343.181519, 133.393402, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj5, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj6 = CreateDynamicObject(19464, 1932.713745, 1341.715942, 131.029907, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj6, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj7 = CreateDynamicObject(19464, 1932.928101, 1343.188721, 133.357803, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj7, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj8 = CreateDynamicObject(19464, 1932.713745, 1340.414551, 131.029907, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj8, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj9 = CreateDynamicObject(19451, 1924.107544, 1344.851318, 128.859406, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj9, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj10 = CreateDynamicObject(19464, 1924.121216, 1340.239624, 131.032104, 0.000000, -1.099900, 90.300003);
	SetDynamicObjectMaterial(cobj10, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj11 = CreateDynamicObject(19464, 1935.551758, 1338.736450, 131.679901, 0.000000, 0.000000, -92.199600);
	SetDynamicObjectMaterial(cobj11, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj12 = CreateDynamicObject(19464, 1927.845825, 1337.258545, 133.393402, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj12, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(18656, 1922.269043, 1341.746704, 127.097000, 89.500000, 0.000000, 0.000000);
	new cobj13 = CreateDynamicObject(19464, 1932.928101, 1337.258545, 133.357803, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj13, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(19622, 1935.754517, 1338.128540, 129.777603, 26.799900, -0.899900, 111.399200);
	CreateObject(957, 1922.272461, 1339.968140, 128.963501, 0.000000, -178.799805, 0.000000);
	CreateObject(19900, 1936.205322, 1338.288940, 129.110504, 0.000000, 0.000000, 90.500000);
	new cobj14 = CreateDynamicObject(19464, 1932.723755, 1337.423218, 134.850006, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj14, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj15 = CreateDynamicObject(19451, 1931.082642, 1335.245605, 128.956207, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj15, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj16 = CreateDynamicObject(19451, 1927.599243, 1335.245605, 128.908203, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj16, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(1649, 1932.593140, 1335.244751, 130.742004, 0.000000, 0.000000, -89.999901);
	new cobj17 = CreateDynamicObject(19464, 1921.056030, 1340.232910, 131.032104, 0.000000, -1.099900, 90.300003);
	SetDynamicObjectMaterial(cobj17, 0, 18031, "cj_exp", "mp_cloth_wall");
	CreateObject(1428, 1938.120850, 1338.061646, 130.653900, 0.000000, 0.000000, 0.000000);
	new cobj18 = CreateDynamicObject(19451, 1934.564941, 1335.245605, 129.004303, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj18, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj19 = CreateDynamicObject(19464, 1922.795044, 1337.258545, 133.428604, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj19, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(2690, 1919.888550, 1340.004761, 130.029404, 0.000000, 0.000000, 1.500200);
	new cobj20 = CreateDynamicObject(19451, 1924.107056, 1335.245605, 128.859406, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj20, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(19832, 1938.873413, 1338.005249, 129.141006, 0.000000, 0.000000, 40.299900);
	CreateObject(19621, 1938.932739, 1337.766602, 129.253204, 0.000000, 0.000000, 119.900002);
	new cobj21 = CreateDynamicObject(19464, 1937.998535, 1337.258545, 133.322601, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj21, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(19832, 1939.268921, 1337.827148, 129.141006, 0.000000, 0.000000, 91.799400);
	CreateObject(1650, 1939.813843, 1337.871338, 129.453003, 0.000000, 0.000000, -91.699600);
	CreateObject(1650, 1940.027222, 1337.910645, 129.233505, 89.899902, -5.099800, -99.399803);
	new cobj22 = CreateDynamicObject(19451, 1938.016113, 1335.245605, 129.052505, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj22, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(18656, 1917.479126, 1341.716553, 127.097603, 89.500000, 0.000000, 0.000000);
	new cobj23 = CreateDynamicObject(19451, 1920.633545, 1335.365723, 128.811401, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj23, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj24 = CreateDynamicObject(19464, 1941.447144, 1338.510132, 131.679901, 0.000000, 0.000000, -92.199600);
	SetDynamicObjectMaterial(cobj24, 0, 18031, "cj_exp", "mp_cloth_wall");
	CreateObject(957, 1917.479736, 1339.938354, 128.904007, 0.000000, -178.799805, 0.000000);
	new cobj25 = CreateDynamicObject(19464, 1927.822632, 1331.345459, 133.393906, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj25, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj26 = CreateDynamicObject(19464, 1932.928101, 1331.348755, 133.357803, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj26, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(1649, 1932.593140, 1330.812622, 130.742004, 0.000000, 0.000000, -89.999901);
	new cobj27 = CreateDynamicObject(1317, 1931.521729, 1330.695435, 128.510101, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj27, 0, 18233, "cuntwshopscs_t", "orange1");
	new cobj28 = CreateDynamicObject(19872, 1937.220337, 1332.798340, 127.579102, 0.000000, 0.000000, 0.400000);
	SetDynamicObjectMaterial(cobj28, 0, 16640, "a51", "metpat64");
	new cobj29 = CreateDynamicObject(19464, 1932.723755, 1331.503540, 134.850006, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj29, 0, 18031, "cj_exp", "mp_cloth_wall");
	CreateObject(2986, 1923.196045, 1332.149048, 133.284302, 0.000000, 0.000000, 0.000000);
	new cobj30 = CreateDynamicObject(19464, 1917.735718, 1337.258545, 133.453506, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj30, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj31 = CreateDynamicObject(19451, 1941.435547, 1335.245605, 129.100403, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj31, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(19903, 1942.470825, 1336.382324, 129.199203, 0.000000, 0.000000, -179.599701);
	new cobj32 = CreateDynamicObject(19464, 1943.013550, 1337.084961, 131.679901, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj32, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj33 = CreateDynamicObject(19464, 1915.124756, 1340.201538, 131.032104, 0.000000, -1.099900, 90.300003);
	SetDynamicObjectMaterial(cobj33, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj34 = CreateDynamicObject(19464, 1943.022949, 1337.258545, 133.287704, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj34, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj35 = CreateDynamicObject(19464, 1922.762817, 1331.345459, 133.429001, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj35, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj36 = CreateDynamicObject(19451, 1917.271851, 1335.305542, 128.764801, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj36, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj37 = CreateDynamicObject(19464, 1937.998657, 1331.348755, 133.322403, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj37, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(1080, 1942.396729, 1334.641235, 129.579407, -9.000000, -29.200001, -174.400101);
	CreateObject(14438, 1927.814941, 1329.151855, 134.728500, 0.000000, 0.000000, -88.799400);
	CreateObject(18656, 1913.088257, 1341.706543, 127.097702, 89.500000, 0.000000, 0.000000);
	CreateObject(19815, 1942.855225, 1333.482544, 132.155502, 0.000000, 0.000000, -90.399902);
	new cobj38 = CreateDynamicObject(19464, 1935.553345, 1328.349243, 131.679901, 0.000000, 0.000000, -92.199600);
	SetDynamicObjectMaterial(cobj38, 0, 18031, "cj_exp", "mp_cloth_wall");
	CreateObject(957, 1913.115356, 1339.938354, 128.825302, 0.000000, -178.799805, 0.000000);
	CreateObject(19900, 1942.544556, 1332.605957, 129.231003, 0.000000, 0.000000, 0.000000);
	CreateObject(19900, 1932.255249, 1326.811646, 129.070602, 0.000000, 0.000000, 0.000000);
	new cobj39 = CreateDynamicObject(19464, 1917.753052, 1331.369141, 133.463104, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj39, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj40 = CreateDynamicObject(19451, 1913.789917, 1335.305542, 128.716400, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj40, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(19900, 1932.255249, 1326.204102, 129.070602, 0.000000, 0.000000, 0.000000);
	new cobj41 = CreateDynamicObject(19464, 1943.013550, 1331.154541, 131.679901, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj41, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj42 = CreateDynamicObject(19451, 1931.082642, 1325.748657, 128.956207, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj42, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj43 = CreateDynamicObject(19464, 1943.063110, 1331.348755, 133.287201, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj43, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj44 = CreateDynamicObject(19464, 1912.653931, 1337.249756, 133.498703, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj44, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj45 = CreateDynamicObject(19451, 1927.590454, 1325.748657, 128.907501, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj45, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(19786, 1932.653320, 1325.768555, 131.269806, 0.000000, 0.000000, -89.799400);
	CreateObject(19899, 1942.395752, 1329.938354, 129.187302, 0.000000, -0.099600, -179.999802);
	CreateObject(19621, 1932.438843, 1325.507202, 129.158905, 0.000000, 0.000000, -66.400002);
	new cobj46 = CreateDynamicObject(19464, 1932.713745, 1325.501953, 131.030106, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj46, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj47 = CreateDynamicObject(19451, 1934.555908, 1325.865723, 129.004303, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj47, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj48 = CreateDynamicObject(19464, 1940.109253, 1328.173950, 131.679901, 0.000000, 0.000000, -92.199600);
	SetDynamicObjectMaterial(cobj48, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj49 = CreateDynamicObject(19464, 1927.822632, 1325.453003, 133.393906, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj49, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj50 = CreateDynamicObject(19464, 1932.928101, 1325.459229, 133.357803, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj50, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj51 = CreateDynamicObject(19451, 1924.097046, 1325.748657, 128.859406, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj51, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(2690, 1910.536743, 1339.891846, 130.029404, 0.000000, 0.000000, 1.500200);
	CreateObject(19900, 1932.255249, 1324.715454, 129.070602, 0.000000, 0.000000, 0.000000);
	new cobj52 = CreateDynamicObject(19451, 1937.995850, 1325.865723, 129.052307, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj52, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj53 = CreateDynamicObject(19464, 1922.762817, 1325.431152, 133.429001, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj53, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(19622, 1932.435547, 1323.993652, 129.767303, 13.300000, 0.000000, 89.699600);
	CreateObject(14438, 1916.673950, 1328.878906, 134.728500, 0.000000, 0.000000, -88.799400);
	new cobj54 = CreateDynamicObject(19451, 1920.604248, 1325.748657, 128.811005, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj54, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj55 = CreateDynamicObject(19464, 1909.202759, 1340.170532, 131.032104, 0.000000, -1.099900, 90.300003);
	SetDynamicObjectMaterial(cobj55, 0, 18031, "cj_exp", "mp_cloth_wall");
	CreateObject(2986, 1923.196045, 1324.708252, 133.284302, 0.000000, 0.000000, 0.000000);
	CreateObject(19627, 1932.168335, 1323.194702, 130.001602, 0.000000, 0.000000, 27.399900);
	new cobj56 = CreateDynamicObject(19451, 1910.307739, 1335.325439, 128.667801, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj56, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(1650, 1932.446533, 1323.195557, 131.988403, 0.000000, 0.000000, -163.599701);
	CreateObject(2134, 1932.110107, 1323.048828, 128.943802, 0.000000, 0.000000, -90.300003);
	CreateObject(2134, 1932.468750, 1323.047119, 130.633804, 0.000000, 0.000000, -90.300003);
	CreateObject(19627, 1932.236206, 1322.932617, 130.001602, 0.000000, 0.000000, -3.499900);
	new cobj57 = CreateDynamicObject(19464, 1912.653931, 1331.369141, 133.498703, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj57, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(2986, 1911.988525, 1332.147461, 133.354202, 0.000000, 0.000000, 0.000000);
	new cobj58 = CreateDynamicObject(19451, 1941.435547, 1325.865723, 129.100403, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj58, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(2040, 1932.412354, 1322.746948, 131.746704, 0.000000, 0.000000, 21.599800);
	CreateObject(18656, 1907.926025, 1341.676636, 127.097900, 89.500000, 0.000000, 0.000000);
	CreateObject(957, 1907.910400, 1339.868042, 128.764404, 0.000000, -178.799805, 0.000000);
	CreateObject(2133, 1932.094849, 1322.108643, 128.947403, 0.000000, 0.000000, -90.299400);
	CreateObject(2040, 1932.401245, 1322.148926, 131.746704, 0.000000, 0.000000, -26.799900);
	CreateObject(2134, 1932.464844, 1322.055542, 130.633804, 0.000000, 0.000000, -90.300003);
	new cobj59 = CreateDynamicObject(19451, 1917.111450, 1325.748657, 128.762604, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj59, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj60 = CreateDynamicObject(19439, 1930.796021, 1321.796509, 128.990204, -0.899900, 90.099800, 89.400101);
	SetDynamicObjectMaterial(cobj60, 0, 14668, "711c", "cj_white_wall2");
	new cobj61 = CreateDynamicObject(19464, 1917.735840, 1325.433960, 133.463501, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj61, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(2134, 1932.100342, 1321.138428, 128.943802, 0.000000, 0.000000, -90.300003);
	new cobj62 = CreateDynamicObject(19464, 1907.553833, 1337.289917, 133.534103, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj62, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(2133, 1932.085449, 1320.176758, 128.947403, 0.000000, 0.000000, -90.299400);
	CreateObject(2134, 1932.455200, 1320.136353, 130.633804, 0.000000, 0.000000, -90.300003);
	new cobj63 = CreateDynamicObject(19451, 1906.826904, 1335.245605, 128.619507, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj63, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj64 = CreateDynamicObject(19451, 1913.629150, 1325.748657, 128.713806, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj64, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj65 = CreateDynamicObject(19464, 1932.713745, 1319.593750, 131.039902, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(cobj65, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj66 = CreateDynamicObject(19464, 1927.845947, 1319.529419, 133.393402, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj66, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj67 = CreateDynamicObject(19451, 1927.590454, 1319.347534, 128.907501, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj67, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj68 = CreateDynamicObject(19464, 1932.928101, 1319.529419, 133.357803, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj68, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(2340, 1932.085449, 1319.173340, 128.945908, 0.000000, 0.000000, -90.699600);
	CreateObject(19921, 1931.970703, 1318.963501, 130.119705, 0.000000, 0.000000, -92.899902);
	new cobj69 = CreateDynamicObject(19451, 1924.097046, 1319.346924, 128.859406, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj69, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj70 = CreateDynamicObject(19464, 1912.653931, 1325.447144, 133.498703, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj70, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj71 = CreateDynamicObject(941, 1930.227905, 1318.602051, 128.564102, 0.000000, -0.599900, 0.699800);
	SetDynamicObjectMaterial(cobj71, 0, 14668, "711c", "cj_white_wall2");
	new cobj72 = CreateDynamicObject(19464, 1907.553833, 1331.375122, 133.534103, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj72, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(19621, 1932.459961, 1318.564453, 131.678802, 0.000000, 0.000000, -34.200001);
	new cobj73 = CreateDynamicObject(19464, 1922.762817, 1319.529419, 133.429001, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj73, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(2340, 1932.082031, 1318.180542, 128.945908, 0.000000, 0.000000, -90.799400);
	new cobj74 = CreateDynamicObject(1744, 1932.770752, 1318.194946, 130.504303, 0.000000, 0.000000, -88.000000);
	SetDynamicObjectMaterial(cobj74, 0, 16644, "a51_detailstuff", "a51_radardisp");
	new cobj75 = CreateDynamicObject(1744, 1932.770752, 1318.194946, 131.254105, 0.000000, 0.000000, -88.000000);
	SetDynamicObjectMaterial(cobj75, 0, 16644, "a51_detailstuff", "a51_radardisp");
	new cobj76 = CreateDynamicObject(19464, 1903.282104, 1340.138550, 131.032104, 0.000000, -1.099900, 90.300003);
	SetDynamicObjectMaterial(cobj76, 0, 18031, "cj_exp", "mp_cloth_wall");
	CreateObject(18656, 1903.185547, 1341.646606, 127.097900, 89.500000, 0.000000, 0.000000);
	new cobj77 = CreateDynamicObject(19451, 1920.607056, 1319.346924, 128.810303, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj77, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(2986, 1911.988525, 1324.708252, 133.354202, 0.000000, 0.000000, 0.000000);
	CreateObject(1650, 1932.447632, 1317.805908, 131.138306, 0.000000, 0.000000, 176.999802);
	CreateObject(957, 1903.216553, 1339.888306, 128.672607, 0.000000, -178.799805, 0.000000);
	CreateObject(1650, 1932.440430, 1317.675659, 131.138306, 0.000000, 0.000000, 176.999802);
	CreateObject(2040, 1932.403442, 1317.624023, 131.686707, 0.000000, 0.000000, 2.900000);
	CreateObject(19942, 1928.840942, 1317.369141, 130.710007, 0.000000, 0.000000, -167.599701);
	new cobj78 = CreateDynamicObject(19451, 1910.125854, 1325.748657, 128.665405, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj78, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(11736, 1929.008423, 1317.301514, 130.257202, 0.000000, 0.000000, -177.199905);
	CreateObject(19893, 1932.127930, 1317.334961, 130.007202, 0.000000, 0.000000, -138.699905);
	CreateObject(2340, 1930.358643, 1317.255005, 128.945908, 0.000000, 0.000000, 179.600006);
	CreateObject(2340, 1931.329224, 1317.240723, 128.945908, 0.000000, 0.000000, 179.300003);
	CreateObject(1650, 1927.613159, 1317.263550, 130.558304, 0.000000, 0.000000, 135.799805);
	CreateObject(19899, 1928.040527, 1317.235352, 128.993103, 0.000000, -0.099600, 90.200104);
	CreateObject(2339, 1932.073730, 1317.205444, 128.937607, 0.000000, 0.000000, -90.800003);
	CreateObject(1650, 1928.040527, 1317.140015, 130.548203, 0.000000, 0.000000, 48.799900);
	CreateObject(2690, 1929.613647, 1317.009521, 129.384201, 0.000000, 0.000000, -176.599701);
	CreateObject(2134, 1930.320313, 1316.879761, 130.633804, 0.000000, 0.000000, -179.900208);
	CreateObject(2040, 1931.615356, 1316.913940, 131.686401, -0.699800, 0.000000, -112.599800);
	CreateObject(1650, 1932.181641, 1316.874634, 131.138306, 0.000000, 0.000000, 131.999802);
	new cobj79 = CreateDynamicObject(19464, 1929.863647, 1316.605957, 131.037704, 0.000000, -0.499900, -89.999901);
	SetDynamicObjectMaterial(cobj79, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj80 = CreateDynamicObject(19451, 1903.394043, 1335.245605, 128.571701, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj80, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj81 = CreateDynamicObject(19464, 1917.735840, 1319.523315, 133.463501, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj81, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj82 = CreateDynamicObject(1744, 1932.173218, 1316.521606, 130.504105, 0.000000, 0.000000, 177.400208);
	SetDynamicObjectMaterial(cobj82, 0, 16644, "a51_detailstuff", "a51_radardisp");
	new cobj83 = CreateDynamicObject(1744, 1932.173218, 1316.521606, 131.254105, 0.000000, 0.000000, 177.400208);
	SetDynamicObjectMaterial(cobj83, 0, 16644, "a51_detailstuff", "a51_radardisp");
	new cobj84 = CreateDynamicObject(19451, 1917.115845, 1319.346924, 128.761505, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj84, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj85 = CreateDynamicObject(19464, 1902.469849, 1337.289551, 133.569504, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj85, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj86 = CreateDynamicObject(19451, 1931.082642, 1316.145508, 128.956207, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj86, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(14438, 1906.402954, 1328.843018, 134.728500, 0.000000, 0.000000, -88.799400);
	new cobj87 = CreateDynamicObject(19464, 1923.931641, 1316.603638, 131.067902, 0.000000, -0.499900, -89.999901);
	SetDynamicObjectMaterial(cobj87, 0, 18031, "cj_exp", "mp_cloth_wall");
	CreateObject(957, 1922.577759, 1316.868042, 128.966705, 0.000000, -178.799805, 0.000000);
	CreateObject(18656, 1922.548340, 1316.690552, 127.695801, 89.500000, 0.000000, 0.000000);
	CreateObject(2690, 1919.912720, 1316.754150, 129.819504, 0.000000, 0.000000, 176.700104);
	new cobj88 = CreateDynamicObject(19464, 1907.553833, 1325.440552, 133.534103, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj88, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(2690, 1900.378174, 1339.890259, 130.029404, 0.000000, 0.000000, 1.500200);
	new cobj89 = CreateDynamicObject(19451, 1906.672607, 1325.748657, 128.617905, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj89, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj90 = CreateDynamicObject(19451, 1913.626343, 1319.346924, 128.712708, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj90, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj91 = CreateDynamicObject(19464, 1918.010254, 1316.595459, 131.068207, 0.000000, -0.499900, -89.999901);
	SetDynamicObjectMaterial(cobj91, 0, 18031, "cj_exp", "mp_cloth_wall");
	CreateObject(957, 1917.433716, 1316.848022, 128.864502, 0.000000, -178.799805, 0.000000);
	new cobj92 = CreateDynamicObject(19464, 1902.459961, 1331.358643, 133.569702, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj92, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj93 = CreateDynamicObject(19464, 1912.653931, 1319.523315, 133.498703, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj93, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(18656, 1917.399414, 1316.687500, 127.405701, 89.500000, 0.000000, 0.000000);
	new cobj94 = CreateDynamicObject(19451, 1899.981934, 1335.245605, 128.524307, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj94, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj95 = CreateDynamicObject(19451, 1910.147461, 1319.346924, 128.664001, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj95, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj96 = CreateDynamicObject(19451, 1903.319458, 1325.748657, 128.571701, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj96, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(957, 1912.692261, 1316.868042, 128.823807, 0.000000, -178.799805, 0.000000);
	new cobj97 = CreateDynamicObject(19464, 1897.344116, 1340.107544, 131.032104, 0.000000, -1.099900, 90.300003);
	SetDynamicObjectMaterial(cobj97, 0, 18031, "cj_exp", "mp_cloth_wall");
	CreateObject(18656, 1912.667847, 1316.687500, 127.405701, 89.500000, 0.000000, 0.000000);
	new cobj98 = CreateDynamicObject(19464, 1912.079346, 1316.576416, 131.067902, 0.000000, -0.499900, -89.999901);
	SetDynamicObjectMaterial(cobj98, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj99 = CreateDynamicObject(19464, 1897.431641, 1337.280518, 133.604706, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj99, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj100 = CreateDynamicObject(19464, 1902.449951, 1325.445923, 133.569702, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj100, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj101 = CreateDynamicObject(19464, 1907.553833, 1319.550537, 133.534103, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj101, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(2986, 1898.658447, 1332.082153, 133.404205, 0.000000, 0.000000, 0.000000);
	CreateObject(2690, 1910.237549, 1316.790039, 129.819504, 0.000000, 0.000000, 176.700104);
	new cobj102 = CreateDynamicObject(19451, 1906.667603, 1319.346924, 128.615402, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj102, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj103 = CreateDynamicObject(19451, 1896.738647, 1335.245605, 128.479401, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj103, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj104 = CreateDynamicObject(19464, 1894.927124, 1341.489258, 131.029205, 0.000000, 0.899900, 0.000000);
	SetDynamicObjectMaterial(cobj104, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj105 = CreateDynamicObject(19464, 1897.431641, 1331.343140, 133.604706, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj105, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	CreateObject(957, 1907.938721, 1316.868042, 128.763306, 0.000000, -178.799805, 0.000000);
	new cobj106 = CreateDynamicObject(19451, 1899.829346, 1325.748657, 128.522903, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj106, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(18656, 1907.927246, 1316.686646, 127.325500, 89.500000, 0.000000, 0.000000);
	new cobj107 = CreateDynamicObject(19464, 1894.927124, 1335.577515, 131.029205, 0.000000, 0.899900, 0.000000);
	SetDynamicObjectMaterial(cobj107, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj108 = CreateDynamicObject(19464, 1906.168335, 1316.576904, 131.067902, 0.000000, -0.499900, -89.999901);
	SetDynamicObjectMaterial(cobj108, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj109 = CreateDynamicObject(19451, 1903.178955, 1319.346924, 128.566605, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj109, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(17951, 1895.126221, 1332.365723, 130.327805, 0.000000, 0.899900, -0.599900);
	CreateObject(2986, 1898.658447, 1324.708252, 133.404205, 0.000000, 0.000000, 0.000000);
	new cobj110 = CreateDynamicObject(19464, 1902.449951, 1319.570557, 133.569702, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj110, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj111 = CreateDynamicObject(19464, 1897.431641, 1325.444702, 133.604706, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj111, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj112 = CreateDynamicObject(19464, 1894.927124, 1329.665649, 131.029205, 0.000000, 0.899900, 0.000000);
	SetDynamicObjectMaterial(cobj112, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj113 = CreateDynamicObject(19451, 1896.737427, 1325.748657, 128.479904, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj113, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(957, 1903.374756, 1316.868042, 128.679001, 0.000000, -178.799805, 0.000000);
	CreateObject(14438, 1894.988525, 1328.713257, 134.728500, 0.000000, 0.000000, -88.799400);
	CreateObject(18656, 1903.305542, 1316.686523, 127.315201, 89.500000, 0.000000, 0.000000);
	new cobj114 = CreateDynamicObject(19451, 1899.689209, 1319.346924, 128.518005, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj114, 0, 11301, "carshow_sfse", "concpanel_la");
	CreateObject(17951, 1895.098022, 1325.154053, 130.326904, 0.000000, 0.899900, -0.599900);
	CreateObject(2690, 1900.899902, 1316.766846, 129.819504, 0.000000, 0.000000, 176.700104);
	new cobj115 = CreateDynamicObject(19464, 1894.927124, 1323.754150, 131.029205, 0.000000, 0.899900, 0.000000);
	SetDynamicObjectMaterial(cobj115, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj116 = CreateDynamicObject(19464, 1900.240601, 1316.577759, 131.068207, 0.000000, -0.499900, -89.999901);
	SetDynamicObjectMaterial(cobj116, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj117 = CreateDynamicObject(19464, 1897.431641, 1319.552734, 133.604706, 0.000000, 90.400002, 0.000000);
	SetDynamicObjectMaterial(cobj117, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1");
	new cobj118 = CreateDynamicObject(19451, 1896.210205, 1319.346924, 128.469101, 0.000000, -90.800003, 0.000000);
	SetDynamicObjectMaterial(cobj118, 0, 11301, "carshow_sfse", "concpanel_la");
	new cobj119 = CreateDynamicObject(19464, 1894.927124, 1317.853149, 131.029205, 0.000000, 0.899900, 0.000000);
	SetDynamicObjectMaterial(cobj119, 0, 18031, "cj_exp", "mp_cloth_wall");
	new cobj120 = CreateDynamicObject(19464, 1894.339111, 1316.577759, 131.068207, 0.000000, -0.499900, -89.999901);
	SetDynamicObjectMaterial(cobj120, 0, 18031, "cj_exp", "mp_cloth_wall");
	return 1;
}

public OnFilterScriptExit()
{
    DOF2_Exit();
	return 1;
}

stock GetLockGaragem(garageid)
{
	new lock[64];
	if(Garagem[garageid][cnLock] == 0)
	{
		lock = "{00F600}Open";
	}
	else if(Garagem[garageid][cnLock] == 1)
	{
		lock = "{F60000}Close";
	}
	else if(Garagem[garageid][cnLock] == 2)
	{
		lock = "{F6F600}Opening";
	}
	else if(Garagem[garageid][cnLock] == 3)
	{
		lock = "{F6F600}Closing";
	}
	return lock;
}

public CarregarGaragens()
{
	new string[256];
    new arquivo[64];
    new arquivoatual[64];
    for(new g=0; g<MAX_GARAGENS; g++)
	{
	    format(arquivoatual, sizeof(arquivoatual), "GaragemAtual.inc", g);
        format(arquivo, sizeof(arquivo), "Garagem%d.inc", g);
        if(DOF2_FileExists(arquivo))
   		{
   		    if(Deletado[g] == false)
   		    {
   		    	new word = g + 10;
    			Garagem[g][cnX] = DOF2_GetFloat(arquivo, "X");
     			Garagem[g][cnY] = DOF2_GetFloat(arquivo, "Y");
      			Garagem[g][cnZ] = DOF2_GetFloat(arquivo, "Z");
      			Garagem[g][cnLock] = DOF2_GetInt(arquivo, "Lock");
      			format(NameString[g], 64, "%s", DOF2_GetString(arquivo, "Owner", NameString[g]));
      			LabelString[g] = DOF2_GetString(arquivo, "Coment", LabelString[g]);
      			GaragemAtual = DOF2_GetInt(arquivoatual, "GGID");
  	    		format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Entry\n%s\n{ED6B79}Owner: %s%s", g, LabelString[g], GetLockGaragem(g), NameString[g]);
   				LabelEntrada[g] = Create3DTextLabel(string, 0xFFFFFFFF, Garagem[g][cnX], Garagem[g][cnY], Garagem[g][cnZ], 30.0, 0, 1 );
   				format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Exit\n%s\n{ED6B79}Owner: %s%s", g, LabelString[g], GetLockGaragem(g), NameString[g]);
   				LabelSaida[g] = Create3DTextLabel(string, 0xFFFFFFFF, COORDENADASGARAGEM, 30.0, word, 1 );
				printf("Garagem Carregada: %d %d %d \nComentario: %s\nDono: %s", Garagem[g][cnX], Garagem[g][cnY], Garagem[g][cnZ], LabelString[g], NameString[g]);
			}
 		}
	}
	return 1;
}

public SalvarGaragens()
{
    new arquivo[64];
    new arquivoatual[64];
    for(new g=0; g<MAX_GARAGENS; g++)
    {
    	format(arquivoatual, sizeof(arquivoatual), "GaragemAtual.inc", g);
        format(arquivo, sizeof(arquivo), "Garagem%d.inc", g);
        if(DOF2_FileExists(arquivo))
   		{
   		    if(Deletado[g] == false)
   		    {
   				DOF2_CreateFile(arquivo);
				DOF2_SetFloat(arquivo, "X", Garagem[g][cnX]);
				DOF2_SetFloat(arquivo, "Y", Garagem[g][cnY]);
				DOF2_SetFloat(arquivo, "Z", Garagem[g][cnZ]);
				DOF2_SetInt(arquivo, "Lock", Garagem[g][cnLock]);
				DOF2_SetString(arquivo, "Coment", LabelString[g]);
  				DOF2_SetString(arquivo, "Owner", NameString[g]);
  				if(!DOF2_FileExists(arquivoatual))
				{
				    if(GaragemAtual <= MAX_GARAGENS)
				    {
						DOF2_CreateFile(arquivoatual);
						DOF2_SetInt(arquivoatual, "GGID", GaragemAtual);
					}
					else
					{
						printf("Reached Maximum Garages, increase the MAX_GARAGENS Garages and renew or delete the file 'GaragemAtual'!");
					}
				}
				else
				{
				    if(GaragemAtual <= MAX_GARAGENS)
				    {
  						DOF2_SetInt(arquivoatual, "GGID", GaragemAtual);
					}
					else
					{
					    printf("Reached Maximum Garages, increase the MAX_GARAGENS Garages and renew or delete the file 'GaragemAtual'!");
					}
				}
			}
			DOF2_SaveFile();
		}
	}
	return 1;
}

public CreateGarage(playerowner[64], garageid, Float:gx, Float:gy, Float:gz, coment[128], bool:lock)
{
 	new string[256];
 	new arquivo[64];
  	format(arquivo, sizeof(arquivo), "Garagem%d.inc", garageid);
  	if(!DOF2_FileExists(arquivo))
  	{
		if(!GarageToPoint(7.0, garageid, gx, gy, gz))
		{
		    if(GaragemAtual <= MAX_GARAGENS)
		    {
 	 			DOF2_CreateFile(arquivo);
 	  			new word = garageid + 10;
   				Garagem[garageid][cnX] = gx;
   				Garagem[garageid][cnY] = gy;
   				Garagem[garageid][cnZ] = gz;
   				Garagem[garageid][cnLock] = lock;
     			NameString[garageid] = playerowner;
   				LabelString[garageid] = coment;
				GaragemAtual ++;
   				format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Entry\n%s\n{ED6B79}Owner: %s%s", garageid, LabelString[garageid], GetLockGaragem(garageid), NameString[garageid]);
   				LabelEntrada[garageid] = Create3DTextLabel(string, 0xFFFFFFFF, gx, gy, gz, 30.0, 0, 1 );
   				format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Exit\n%s\n{ED6B79}Owner: %s%s", garageid, LabelString[garageid], GetLockGaragem(garageid), NameString[garageid]);
   				LabelSaida[garageid] = Create3DTextLabel(string, 0xFFFFFFFF, COORDENADASGARAGEM, 30.0, word, 1 );
   				printf("Garage Built: %d %d %d \nComent: %s\nOwner: %s", Garagem[garageid][cnX], Garagem[garageid][cnY], Garagem[garageid][cnZ], LabelString[garageid], NameString[garageid]);
   				SalvarGaragens();
			}
			else
			{
			    printf("Reached Maximum Garages, increase the MAX_GARAGENS Garages and renew or delete the file 'GaragemAtual'!");
			}
		}
		else
		{
		    printf("There is already a garage at this radius.");
		}
	}
	else
	{
	    printf("There is this GarageID.");
	}
	return 1;
}

public DeletarGaragem(garageid)
{
    new arquivo[64];
    new string[128];
    format(arquivo, sizeof(arquivo), "Garagem%d.inc", garageid);
   	if(!DOF2_FileExists(arquivo))
   	{
		printf("There is this GarageID.");
		return 1;
	}
	else
	{
	    for(new i = 0; i < MAX_PLAYERS; i++)
		{
			for(new v = 0; v < MAX_VEHICLES; v++)
			{
			    if(garageid == GetVehicleVirtualWorld(v)-10)
 		    	{
   					if(!IsPlayerInVehicle(i, v))
  		   			{
   	   					SetVehicleVirtualWorld(v, 0);
   	   					SetVehicleToRespawn(v);
					}
   				}
			}
		    if(garageid == GetPlayerVirtualWorld(i)-10)
    	    {
	   	        if(GetPlayerState(i) == PLAYER_STATE_ONFOOT)
				{
					SetPlayerPos(i, Garagem[garageid][cnX], Garagem[garageid][cnY], Garagem[garageid][cnZ]);
	    			SetPlayerVirtualWorld(i, 0);
	    			SetPlayerInterior(i, 0);
	    			format(string, sizeof(string), "The Garage %d{00AB00} was deleted.", garageid);
		    		SendClientMessage(i, COR_SUCESSO, string);
				}
				else
				{
					new tmpcar = GetPlayerVehicleID(i);
					SetVehiclePos(tmpcar, Garagem[garageid][cnX], Garagem[garageid][cnY], Garagem[garageid][cnZ]);
					SetVehicleVirtualWorld(tmpcar, 0);
					SetPlayerVirtualWorld(i, 0);
					SetPlayerInterior(i, 0);
					format(string, sizeof(string), "The Garage %d{00AB00} was deleted.", garageid);
		    		SendClientMessage(i, COR_SUCESSO, string);
				}
			}
		}
	    DOF2_RemoveFile(arquivo);
	    Deletado[garageid] = true;
	    Delete3DTextLabel(LabelSaida[garageid]);
	    Delete3DTextLabel(LabelEntrada[garageid]);
	    printf("Garagem %d foi deletada", garageid);
	    SalvarGaragens();
	}
	return 1;
}

public SetGaragemComent(garageid, coment[128])
{
    new arquivo[64];
    new string[128];
    format(arquivo, sizeof(arquivo), "Garagem%d.inc", garageid);
   	if(!DOF2_FileExists(arquivo))
   	{
		printf("There is this GarageID.");
		return 1;
	}
	else
	{
	    if(Deletado[garageid] == false)
        {
	    	printf("The Comment of garage %d has changed", garageid);
	    	LabelString[garageid] = coment;
	    	format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Entry\n%s\n{ED6B79}Owner: %s%s", garageid, LabelString[garageid], GetLockGaragem(garageid), NameString[garageid]);
			Update3DTextLabelText(LabelEntrada[garageid], 0xFFFFFFFF, string);
			format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Exit\n%s\n{ED6B79}Owner: %s%s", garageid, LabelString[garageid], GetLockGaragem(garageid), NameString[garageid]);
			Update3DTextLabelText(LabelSaida[garageid], 0xFFFFFFFF, string);
	 		SalvarGaragens();
		}
	}
	return 1;
}

public SetGaragemDono(garageid, playerowner[64])
{
    new arquivo[64];
    new string[128];
    format(arquivo, sizeof(arquivo), "Garagem%d.inc", garageid);
   	if(!DOF2_FileExists(arquivo))
   	{
		printf("There is this GarageID.");
		return 1;
	}
	else
	{
	    if(Deletado[garageid] == false)
        {
	    	printf("The owner of Garage %d has changed", garageid);
	    	NameString[garageid] = playerowner;
	    	format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Entry\n%s\n{ED6B79}Owner: %s%s", garageid, LabelString[garageid], GetLockGaragem(garageid), NameString[garageid]);
			Update3DTextLabelText(LabelEntrada[garageid], 0xFFFFFFFF, string);
			format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Exit\n%s\n{ED6B79}Owner: %s%s", garageid, LabelString[garageid], GetLockGaragem(garageid), NameString[garageid]);
			Update3DTextLabelText(LabelSaida[garageid], 0xFFFFFFFF, string);
 			SalvarGaragens();
		}
	}
	return 1;
}

public SetGaragemPos(garageid, Float:gx, Float:gy, Float:gz)
{
    new arquivo[64];
    new string[128];
    format(arquivo, sizeof(arquivo), "Garagem%d.inc", garageid);
   	if(!DOF2_FileExists(arquivo))
   	{
		printf("There is this GarageID.");
		return 1;
	}
	else
	{
	    if(Deletado[garageid] == false)
        {
	    	printf("The Post's Garage %d has changed", garageid);
    		Garagem[garageid][cnX] = gx;
    		Garagem[garageid][cnY] = gy;
    		Garagem[garageid][cnZ] = gz;
    		Delete3DTextLabel(LabelEntrada[garageid]);
	  		format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Entry\n%s\n{ED6B79}Owner: %s%s", garageid, LabelString[garageid], GetLockGaragem(garageid), NameString[garageid]);
			LabelEntrada[garageid] = Create3DTextLabel(string, 0xFFFFFFFF, gx, gy, gz, 30.0, 0, 1 );
	    	SalvarGaragens();
		}
	}
	return 1;
}

public GarageToPoint(Float:radi, garageid, Float:x, Float:y, Float:z)
{
    for(new g=0; g<MAX_GARAGENS; g++)
    {
        if(Deletado[g] == false)
        {
			new Float:oldposx, Float:oldposy, Float:oldposz;
			new Float:tempposx, Float:tempposy, Float:tempposz;
			oldposx = Garagem[g][cnX];
			oldposy = Garagem[g][cnY];
			oldposz = Garagem[g][cnZ];
			tempposx = (oldposx -x);
			tempposy = (oldposy -y);
			tempposz = (oldposz -z);
			if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
			{
				return 1;
			}
		}
	}
	return 0;
}

public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}

public FecharGaragem(playerid, garageid)
{
    if(Deletado[garageid] == false)
    {
    	SendClientMessage(playerid, COR_SUCESSO, "The gate was {F60000}Close {00AB00}fully.");
    	Garagem[garageid][cnLock] = 1;
    	new string[256];
    	format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Entry\n%s\n{ED6B79}Owner: %s%s", garageid, LabelString[garageid], GetLockGaragem(garageid), NameString[garageid]);
		Update3DTextLabelText(LabelEntrada[garageid], 0xFFFFFFFF, string);
		format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Exit\n%s\n{ED6B79}Owner: %s%s", garageid, LabelString[garageid], GetLockGaragem(garageid), NameString[garageid]);
		Update3DTextLabelText(LabelSaida[garageid], 0xFFFFFFFF, string);
		SalvarGaragens();
	}
	return 1;
}

public AbrirGaragem(playerid, garageid)
{
    if(Deletado[garageid] == false)
    {
    	SendClientMessage(playerid, COR_SUCESSO, "The gate was {00F600}Open {00AB00}fully.");
    	Garagem[garageid][cnLock] = 0;
    	new string[256];
    	format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Entry\n%s\n{ED6B79}Owner: %s%s", garageid, LabelString[garageid], GetLockGaragem(garageid), NameString[garageid]);
		Update3DTextLabelText(LabelEntrada[garageid], 0xFFFFFFFF, string);
		format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Exit\n%s\n{ED6B79}Owner: %s%s", garageid, LabelString[garageid], GetLockGaragem(garageid), NameString[garageid]);
		Update3DTextLabelText(LabelSaida[garageid], 0xFFFFFFFF, string);
		SalvarGaragens();
	}
	return 1;
}

public Creditos()
{
    SendClientMessageToAll(-1, "Garage System made by CidadeNovaRP.");
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{

    if(strcmp(cmdtext, "/editgarage", true) == 0)
    {
        if(IsPlayerAdmin(playerid))
        {
        	for(new g=0; g<MAX_GARAGENS; g++)
    		{
				if(PlayerToPoint(3.0, playerid, Garagem[g][cnX], Garagem[g][cnY], Garagem[g][cnZ]))
				{
				    if(Deletado[g] == false)
				    {
				        EditandoGaragem[playerid] = g;
     					ShowPlayerDialog(playerid, 5555, DIALOG_STYLE_MSGBOX, "Create/Edit Garage","Click on 'My Name' for you are the owner or 'Edit' to change the Owner", "My Name", "Edit");
					}
				}
			}
		}
		return 1;
	}

	if(strcmp(cmdtext, "/creategarage", true) == 0)
    {
        if(IsPlayerAdmin(playerid))
        {
  			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			EditandoGaragem[playerid] = GaragemAtual+1;
			if(!GarageToPoint(7.0, EditandoGaragem[playerid], x, y, z))
			{
				ShowPlayerDialog(playerid, 5555, DIALOG_STYLE_MSGBOX, "Create/Edit Garage","Click on 'My Name' for you are the owner or 'Edit' to change the Owner", "My Name", "Edit");
  				CreateGarage("", GaragemAtual+1, x, y, z, "", true);
			}
		}
		return 1;
	}

	if(strcmp(cmdtext, "/removegarage", true) == 0)
    {
        if(IsPlayerAdmin(playerid))
        {
        	for(new g=0; g<MAX_GARAGENS; g++)
    		{
				if(PlayerToPoint(3.0, playerid, Garagem[g][cnX], Garagem[g][cnY], Garagem[g][cnZ]))
				{
				    if(Deletado[g] == false)
				    {
						DeletarGaragem(g);
					}
				}
			}
		}
		return 1;
	}

	if (strcmp("/gclose", cmdtext, true, 10) == 0)
	{
     	new string[256];
     	new playername[24];
	    for(new g=0; g<MAX_GARAGENS; g++)
    	{
			if(PlayerToPoint(3.0, playerid, Garagem[g][cnX], Garagem[g][cnY], Garagem[g][cnZ]) || PlayerToPoint(3.0, playerid, COORDENADASGARAGEM) && g == GetPlayerVirtualWorld(playerid)-10)
			{
				GetPlayerName(playerid,playername,24);
				if(!strcmp(NameString[g],playername,true) || IsPlayerAdmin(playerid))
				{
				    if(Deletado[g] == false)
				    {
  						if(Garagem[g][cnLock] == 0)
	    				{
							SetTimerEx("FecharGaragem", 5000, false, "ii", playerid, g);
							Garagem[g][cnLock] = 3;
							SendClientMessage(playerid, COR_SUCESSO, "The Gate is {F6F600}Closing{00AB00}.");
							format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Entry\n%s\n{ED6B79}Owner: %s%s", g, LabelString[g], GetLockGaragem(g), NameString[g]);
							Update3DTextLabelText(LabelEntrada[g], 0xFFFFFFFF, string);
							format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Exit\n%s\n{ED6B79}Owner: %s%s", g, LabelString[g], GetLockGaragem(g), NameString[g]);
							Update3DTextLabelText(LabelSaida[g], 0xFFFFFFFF, string);
							break;
						}
						else
						{
						    format(string, sizeof(string), "The Gate is %s{AD0000}.", GetLockGaragem(g));
						    SendClientMessage(playerid, COR_ERRO, string);
						}
					}
				}
				else
				{
					SendClientMessage(playerid, COR_ERRO, "You are not owner of this garage.");
				}
			}
		}
	    return 1;
	}

	if (strcmp("/gopen", cmdtext, true, 10) == 0)
	{
	    new string[256];
	    new playername[24];
	    for(new g=0; g<MAX_GARAGENS; g++)
    	{
			if(PlayerToPoint(3.0, playerid, Garagem[g][cnX], Garagem[g][cnY], Garagem[g][cnZ]) || PlayerToPoint(3.0, playerid, COORDENADASGARAGEM) && g == GetPlayerVirtualWorld(playerid)-10)
			{
       			GetPlayerName(playerid,playername,24);
				if(!strcmp(NameString[g],playername,true) || IsPlayerAdmin(playerid))
				{
				    if(Deletado[g] == false)
				    {
						if(Garagem[g][cnLock] == 1)
 						{
							SetTimerEx("AbrirGaragem", 5000, false, "ii", playerid, g);
							Garagem[g][cnLock] = 2;
							SendClientMessage(playerid, COR_SUCESSO, "The Gate is {F6F600}Opening{00AB00}.");
							format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Entry\n%s\n{ED6B79}Owner: %s%s", g, LabelString[g], GetLockGaragem(g), NameString[g]);
							Update3DTextLabelText(LabelEntrada[g], 0xFFFFFFFF, string);
							format(string, sizeof(string), "{0000F6}[GARAGE ID: %d]\n{00F6F6}%s\n{0000F6}Exit\n%s\n{ED6B79}Owner: %s%s", g, LabelString[g], GetLockGaragem(g), NameString[g]);
							Update3DTextLabelText(LabelSaida[g], 0xFFFFFFFF, string);
							break;
						}
						else
						{
						    format(string, sizeof(string), "The Gate is %s{AD0000}.", GetLockGaragem(g));
						    SendClientMessage(playerid, COR_ERRO, string);
						}
					}
				}
				else
				{
					SendClientMessage(playerid, COR_ERRO, "You are not owner of this garage.");
				}
			}
		}
	    return 1;
	}

	if (strcmp("/enter", cmdtext, true, 10) == 0)
	{
		new string[64];
	    for(new g=0; g<MAX_GARAGENS; g++)
    	{
			if(PlayerToPoint(3.0, playerid, Garagem[g][cnX], Garagem[g][cnY], Garagem[g][cnZ]))
			{
			    if(Garagem[g][cnLock] == 0)
			    {
			        if(Deletado[g] == false)
			        {
						if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
						{
							SetPlayerPos(playerid, COORDENADASGARAGEM);
							SetPlayerVirtualWorld(playerid, g+10);
							SetPlayerInterior(playerid, 2);
							format(string, sizeof(string), "Welcome to Garage %d.", g);
				    		SendClientMessage(playerid, COR_SUCESSO, string);
						}
						else
						{
						    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
       						{
								if(Garagem[g][cnCar] <= MAX_CARS)
							    {
              						for(new i = 0; i < MAX_PLAYERS; i++)
						        	{
										new tmpcar = GetPlayerVehicleID(playerid);
        								if(IsPlayerInVehicle(i, tmpcar))
        								{
											SetPlayerVirtualWorld(i, g+10);
											SetPlayerInterior(playerid, 2);
											Garagem[g][cnCar] ++;
											SetVehicleVirtualWorld(tmpcar, g+10);
											LinkVehicleToInterior(tmpcar, 2);
											SetVehiclePos(tmpcar, COORDENADASGARAGEM);
											format(string, sizeof(string), "Welcome to Garage %d.", g);
 											SendClientMessage(i, COR_SUCESSO, string);
										}
									}
    							}
    							else
			    				{
			    				    SendClientMessage(playerid, COR_ERRO, "You already have the maximum accepted vehicles in the garage.");
			    				}
				    		}
			    			else
			    			{
			    			    SendClientMessage(playerid, COR_ERRO, "Drivers can only enter and exit the garage.");
			    			}
						}
					}
				}
				else
				{
				    format(string, sizeof(string), "The Gate is %s{AD0000}.", GetLockGaragem(g));
				    SendClientMessage(playerid, COR_ERRO, string);
				    break;
				}
			}
		}
	    return 1;
	}

	if (strcmp("/exit", cmdtext, true, 10) == 0)
	{
		new string[128];
		for(new g=0; g<MAX_GARAGENS; g++)
    	{
    	    if(g == GetPlayerVirtualWorld(playerid)-10)
    	    {
	    		if(PlayerToPoint(3.0, playerid, COORDENADASGARAGEM))
    			{
    			    if(Garagem[g][cnLock] == 0)
    			    {
        		    	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
						{
							SetPlayerPos(playerid, Garagem[g][cnX], Garagem[g][cnY], Garagem[g][cnZ]);
							SetPlayerVirtualWorld(playerid, 0);
							SetPlayerInterior(playerid, 0);
							format(string, sizeof(string), "Return always the Garage %d.", g);
				    		SendClientMessage(playerid, COR_SUCESSO, string);
						}
						else
						{
						    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
             				{
              					for(new i = 0; i < MAX_PLAYERS; i++)
				        		{
									new tmpcar = GetPlayerVehicleID(playerid);
        							if(IsPlayerInVehicle(i, tmpcar))
        							{
										SetPlayerVirtualWorld(i, 0);
										SetPlayerInterior(playerid, 0);
										Garagem[g][cnCar] --;
										SetVehicleVirtualWorld(tmpcar, 0);
										LinkVehicleToInterior(tmpcar, 0);
										SetVehiclePos(tmpcar, Garagem[g][cnX], Garagem[g][cnY], Garagem[g][cnZ]);
										format(string, sizeof(string), "Return always the Garage %d.", g);
 										SendClientMessage(i, COR_SUCESSO, string);
									}
								}
				    		}
			    			else
			    			{
			    			    SendClientMessage(playerid, COR_ERRO, "Drivers can only enter and exit the garage.");
			    			}
						}
     				}
					else
					{
     					format(string, sizeof(string), "The Gate is %s{AD0000}.", GetLockGaragem(g));
     					SendClientMessage(playerid, COR_ERRO, string);
     					break;
					}
    			}
   			}
  		}
	    return 1;
	}
	return 0;
}

public OnVehicleSpawn(vehicleid)
{
    for(new g=0; g<MAX_GARAGENS; g++)
	{
 		if(g == GetVehicleVirtualWorld(vehicleid)-10)
   		{
   			SetVehicleVirtualWorld(vehicleid, 0);
   			Garagem[g][cnCar] --;
		}
	}
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 5555)
	{
	    if(response)
		{
			new playername[64];
			GetPlayerName(playerid, playername, sizeof(playername));
			SetGaragemDono(EditandoGaragem[playerid], playername);
			ShowPlayerDialog(playerid, 5557, DIALOG_STYLE_INPUT, "Create/Edit Garage", "Enter a Comment that will appear in the Label\nNote: If you do not want to leave the space blank and go", "End", "");
		}
		else
		{
			ShowPlayerDialog(playerid, 5556, DIALOG_STYLE_INPUT, "Create/Edit Garage", "Enter Nick the owner (not the ID)\nNote: Whether the player is online or not\nNote: If you do not want to leave the space blank and go", "Next", "");
		}
	}
	if(dialogid == 5556)
	{
	    if(response)
		{
		    if(!strlen(inputtext))
			{
			    SetGaragemDono(EditandoGaragem[playerid], "Nobody");
			    ShowPlayerDialog(playerid, 5557, DIALOG_STYLE_INPUT, "Create/Edit Garage", "Enter a Comment that will appear in the Label\nNote: If you do not want to leave the space blank and go", "End", "");
			}
			else
			{
		    	new string[64];
		    	format(string, sizeof(string), "%s", inputtext);
   				SetGaragemDono(EditandoGaragem[playerid], string);
   				ShowPlayerDialog(playerid, 5557, DIALOG_STYLE_INPUT, "Create/Edit Garage", "Enter a Comment that will appear in the Label\nNote: If you do not want to leave the space blank and go", "End", "");
			}
		}
		else
		{
		}
	}
	if(dialogid == 5557)
	{
	    if(response)
		{
      		if(!strlen(inputtext))
			{
			    new string[128];
		    	format(string, sizeof(string), "No Comment");
       			SetGaragemComent(EditandoGaragem[playerid], string);
			}
			else
			{
     			new string[128];
		    	format(string, sizeof(string), "%s", inputtext);
   				SetGaragemComent(EditandoGaragem[playerid], string);
   			}
		}
		else
		{
		}
	}
	return 1;
}
