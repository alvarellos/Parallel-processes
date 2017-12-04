
-- Cláusula de contexto: uso de la librería "Text_IO"
-- Proporciona servicios básicos de E/S
with Ada.Text_IO; use Ada.Text_IO;

procedure Concurrente is

-- Procedimientos
---------------------------------------------------------------------------------
-- Se define los Procedimento sin parámetros, cada elemento del array es un apuntador a uno de ellos
-- Se retarda la llamada de escritura de los procedimientos uno y dos, de esa forma se evita que se muestren los mensajes al mismo tiempo.

procedure ProcedimientoUno is
begin
	Put_Line("Procedimiento Uno Finalizado!!");
end ProcedimientoUno;

---------------------------------------------------------------------------------

procedure ProcedimientoDos is
begin
	delay 1.0;
	Put_Line("Procedimiento Dos Finalizado!!");
end ProcedimientoDos;

---------------------------------------------------------------------------------

procedure ProcedimientoTres is
begin
	delay 2.0;
	Put_Line("Procedimiento Tres Finalizado!!");
end ProcedimientoTres;

---------------------------------------------------------------------------------

--TipoPuntero: permite llamar a un subprograma sin conocer su nombre ni su ubicación
type TipoPuntero is access procedure;
-- TipoParametros: array no restingido de tipo TipoPuntero
type TipoParametros is array(Positive range <>) of TipoPuntero;

---------------------------------------------------------------------------------

-- EjecutarConcurrentemente: recibe como argumento un tipo TipoParametros (array ilimitado del tipo TipoPuntero)
-- Tarea Principal: recibe como argumentos un TipoPuntero (permite llamar a un subprograma sin conocer su nombre ni su ubicación)

procedure EjecutarConcurentemente (Entrada : TipoParametros) is
task type TareaPrincipal(Puntero: TipoPuntero);
task body TareaPrincipal is
begin
	Puntero.all;
end TareaPrincipal;

-- Tipo de los punteros a TareaPrincipal dinámicos
type TareaPrincipal_TipoPuntero is access TareaPrincipal;
Starter : TareaPrincipal_TipoPuntero; --variable estatica de tipo TareaPrincipal

begin -- Cuerpo EjecutarConcurrentemente
	Put_Line("EjecutarConcurrentemente Inicializada");
	-- Iteración desde el límite inferior del Array Entrada (que pasado como argumento) hasta su límite superior
	for i in Entrada'Range loop
	-- Variable dinámica de tipo Worker, inicializada con el valor de la iteración contenido en Entrada
	Starter := new TareaPrincipal(Entrada(i));
	end loop;
	Put_Line("EjecutarConcurrentemente Finalizada");
end EjecutarConcurentemente;

---------------------------------------------------------------------------------

-- Inicio procedimiento principal (Concurrente)

-- Se llama a EjecutarConcurrentemente, el cual admite un array ilimitado
-- Esta llamada ejecuta todos los procediemientos, en este caso los tres que han sido declarados.

begin
Put_Line("Iniciado Programa Principal");
EjecutarConcurentemente((ProcedimientoUno'access, ProcedimientoDos'access, ProcedimientoTres'Access)) ;
Put_Line("Programa Principal Finalizado");
end Concurrente;
