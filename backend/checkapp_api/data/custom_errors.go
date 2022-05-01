package data

var ErrorCodeMap = map[int]string{

	1:  "No ha pasado suficiente tiempo desde tu ultima salida.",
	2:  "Necesitas marcar tu entrada antes de continuar.",
	3:  "Necesitas marcar tu salida antes de continuar.",
	4:  "El QR escaneado no corresponde al de tu empresa.",
	5:  "El dispositivo utilizado no corresponde al registrado en nuestros sistemas.",
	6:  "El tipo de evento ingresado no es valido.",
	7:  "La ubicacion ingresada no tiene un formato valido.",
	8:  "La ubicacion de la empresa no tiene un formato valido.",
	9:  "Te encuentras demasiado lejos de tu empresa",
	10: "Tienes el dia libre.",
	11: "Ya has marcado tu entrada el dia de hoy.",
	12: "Ya has marcado tu salida el dia de hoy.",
	13: "No estas autorizado para realizar esta operacion.",
}
