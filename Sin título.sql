DROP TABLE IF EXISTS categorias_unidades_medida CASCADE;
DROP TABLE IF EXISTS unidades_medida CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS detalle_pedido;
DROP TABLE IF EXISTS detalle_ventas;
DROP TABLE IF EXISTS cabecera_ventas;
DROP TABLE IF EXISTS proveedores CASCADE;
DROP TABLE IF EXISTS estados_pedido CASCADE;
DROP TABLE IF EXISTS tipo_documento;
DROP TABLE IF EXISTS cabecera_pedido;
DROP TABLE IF EXISTS historial_stock;

create table categorias_unidades_medida(
    codigo_udm char(1) PRIMARY KEY not null,
	nombre varchar(100) not null
);

create table unidades_medida(
    codigo_udm char(2) PRIMARY KEY not null,
	descripción varchar(100) not null,
	categoria_udm char(1),
	foreign key (categoria_udm) references categorias_unidades_medida(codigo_udm)
);

create table categorias(
    codigo_cat serial  PRIMARY KEY not null,
	nombre varchar(100) not null,
	categoria_padre int,
	foreign key (categoria_padre) references categorias(codigo_cat)
);

create table productos(
    codigo_producto serial primary key not null,
	nombre varchar(100) not null,
	codigo_udm char(2) not null,
	precio_venta money not null,
	tiene_iva boolean not null,
	coste money not null,
	cod_categoria int not null,
	stock int not null,
	CONSTRAINT fk_productos_udm foreign key (codigo_udm) references unidades_medida(codigo_udm),
	CONSTRAINT fk_producto_categorias foreign key (cod_categoria) references categorias(codigo_cat)
);
create table cabecera_ventas(
	codigo serial primary key not null,
	fecha timestamp not null,
	total_sin_iva money not null,
	iva money not null,
	total money not null
);
create table detalle_ventas(
	codigo serial primary key not null,
    cabecera_ventas int  not null,
	producto int not null,
	cantidad int not null,
	precio_venta money not null,
	subtotal money not null,
	subtotal_iva money not null,
	CONSTRAINT fk_detalle_ventas_cv foreign key (cabecera_ventas) references cabecera_ventas(codigo),
	CONSTRAINT fk_detalle_ventas_producto foreign key (producto) references productos(codigo_producto)
);

create table historial_stock(
	codigo serial primary key not null,
	fecha timestamp without time zone not null,
	reference varchar(100) not null,
	producto int not null,
	cantidad int not null,
	CONSTRAINT fk_historial_stock_producto foreign key (producto) references productos(codigo_producto)
);
create table tipo_documento(
	codigo_td char(1) primary key not null,
	descripción varchar(100) not null
);
create table proveedores(
	identificador char(13) primary key not null,
	tipo_documento char(1) not null,
	nombre varchar(100) not null,
	telefono  char(10) not null,
	correo  varchar(100) not null,
	direccion  varchar(100) not null,
	CONSTRAINT fk_proveedores_td foreign key (tipo_documento) references tipo_documento(codigo_td)
);
create table estados_pedido(
	codigo char(1) primary key not null,
	descripción varchar(100) not null
);
create table cabecera_pedido(
	numero_pedido serial primary key not null,
	cod_proveedor char(13) not null,
	fecha date not null,
	estado char(1) not null,
	CONSTRAINT fk_cabecera_pedido_proveedor foreign key (cod_proveedor) references proveedores(identificador),
	CONSTRAINT fk_cabecera_pedido_estado foreign key (estado) references estados_pedido(codigo)
);
create table detalle_pedido(
	codigo serial primary key not null,
	cabecera_pedido int not null,
	producto int not null,
	cantidad int not null,
	subtotal money not null,
	cantidad_recibida int not null,
	CONSTRAINT fk_detalle_pedido_cabecera_pedido foreign key (cabecera_pedido) references cabecera_pedido(numero_pedido),
	CONSTRAINT fk_detalle_pedido_producto foreign key (producto) references productos(codigo_producto)
);

insert into categorias_unidades_medida values ('U','Unidades');
insert into categorias_unidades_medida values ('V','Volumen');
insert into categorias_unidades_medida values ('P','Peso');

insert into unidades_medida values ('ml','milimetros','V');
insert into unidades_medida values ('l','litros','V');
insert into unidades_medida values ('u','unidad','U');
insert into unidades_medida values ('d','docenas','U');
insert into unidades_medida values ('g','gramos','P');
insert into unidades_medida values ('kg','kilogramos','P');
insert into unidades_medida values ('lb','libras','P');

insert into categorias(nombre) values ('materia prima');
insert into categorias(nombre,categoria_padre) values ('proteina',1);
insert into categorias(nombre,categoria_padre) values ('salsa',1);
insert into categorias(nombre) values ('Punto de venta');
insert into categorias(nombre,categoria_padre) values ('bebidas',4);
insert into categorias(nombre,categoria_padre) values ('alcohol',5);
insert into categorias(nombre,categoria_padre) values ('sin alcohol',5);

insert into productos(nombre,codigo_udm,precio_venta,tiene_iva,coste,cod_categoria,stock ) values ('Coca cola pequeña','u',0.5804,true,0.3729,7,110);
insert into productos(nombre,codigo_udm,precio_venta,tiene_iva,coste,cod_categoria,stock ) values ('Salsa de tomate','kg',0.95,true,0.8736,3,0);
insert into productos(nombre,codigo_udm,precio_venta,tiene_iva,coste,cod_categoria,stock ) values ('Mostaza','kg',0.95,true,0.89,3,0);
insert into productos(nombre,codigo_udm,precio_venta,tiene_iva,coste,cod_categoria,stock ) values ('Fuze tea','u',0.8,true,0.7,2,50);


insert into tipo_documento values ('C','CEDULA');
insert into tipo_documento values ('R','RUC');

insert into proveedores values ('1792285747','C','Santiago Mosquera','0992920306','santyb89@gmail.com','Cumbayork');
insert into proveedores values ('1792285747001','R','Snacks SA','0992920398','snacks@gmail.com','La Tola');

insert into  estados_pedido values ('S','Solicitado');
insert into  estados_pedido values ('R','Recibido');

insert into cabecera_pedido(cod_proveedor,fecha,estado) values ('1792285747','2023/11/20','R');
insert into cabecera_pedido(cod_proveedor,fecha,estado) values ('1792285747','2023/11/20','R');


insert into detalle_pedido(cabecera_pedido,producto,cantidad,subtotal,cantidad_recibida) values (1,1,100,37.29,100);
insert into detalle_pedido(cabecera_pedido,producto,cantidad,subtotal,cantidad_recibida) values (1,4,50,11.8,50);
insert into detalle_pedido(cabecera_pedido,producto,cantidad,subtotal,cantidad_recibida) values (2,1,10,3.73,10);

insert into  historial_stock(fecha,reference,producto,cantidad) values ('2023/11/20 19:59','Pedido 1',1,100);
insert into  historial_stock(fecha,reference,producto,cantidad) values ('2023/11/20 19:59','Pedido 1',4,50);
insert into  historial_stock(fecha,reference,producto,cantidad) values ('2023/11/20 20:00','Pedido 2',1,10);

insert into  cabecera_ventas(fecha,total_sin_iva,iva,total) values ('2023/11/20 20:00',3.26,0.39,3.65);

insert into  detalle_ventas(cabecera_ventas,producto,cantidad,precio_venta,subtotal,subtotal_iva) values (1,1,5,0.58,2.9,3.25);
insert into  detalle_ventas(cabecera_ventas,producto,cantidad,precio_venta,subtotal,subtotal_iva) values (1,4,1,0.36,0.36,0.4);