
CREATE TABLE precio(
precio_id NUMERIC(10,0) NOT NULL,
monto NUMERIC(8,3) NOT NULL,
fecha_inicio DATE NOT NULL,
fecha_final DATE NOT NULL,
dias_vigencia NUMBER GENERATED ALWAYS AS(fecha_final-fecha_inicial) VIRTUAL,
CONSTRAINT precio_id_pk PRIMARY KEY(precio_id)		
);


CREATE TABLE producto(
folio_control VARCHAR(13) NOT NULL,
numero_reproducciones NUMERIC(10,0) NOT NULL,
url VARCHAR(50) NOT NULL,
precio_id NUMERIC(10,0) NOT NULL,
CONSTRAINT folio_control_pk PRIMARY KEY(folio_control),
CONSTRAINT precio_id_fk FOREIGN KEY(precio_id) REFERENCES precio(precio_id),
CONSTRAINT url_uk UNIQUE(url)
);


CREATE TABLE album(
album_id NUMERIC(10,0) NOT NULL,
nombre_artista VARCHAR(30) NOT NULL,
nombre_album VARCHAR(30) NOT NULL,
anio VARCHAR(4) NOT NULL,
disquera VARCHAR(15) NOT NULL,
folio_control VARCHAR(13) NOT NULL,
CONSTRAINT album_id_pk PRIMARY KEY(album_id),
CONSTRAINT folio_control_fk FOREIGN KEY(folio_control) REFERENCES producto(folio_control)
);


CREATE TABLE pelicula(
pelicula_id NUMERIC(10,0) NOT NULL,
nombre VARCHAR(30) NOT NULL,
genero VARCHAR(15) NULL,
duracion VARCHAR(3) NULL,
clasificacion VARCHAR(1) DEFAULT "C",
formato_video VARCHAR(10) NOT NULL,
folio_control VARCHAR(13) NOT NULL,
CONSTRAINT pelicula_id_pk PRIMARY KEY(pelicula_id),
CONSTRAINT folio_control_fk FOREIGN KEY(folio_control) REFERENCES producto(folio_control),
CONSTRAINT clasificacion_ck CHECK(clasificacion IN ("A","B","C"))
);



CREATE TABLE videojuego(
videojuego_id NUMERIC(10,0) NOT NULL,
nombre VARCHAR(15) NOT NULL,
consola VARCHAR(10) NOT NULL,
descripcion VARCHAR(250) NULL,
folio_control VARCHAR(13) NOT NULL,
CONSTRAINT videojuego_id_pk PRIMARY KEY(videojuego_id),
CONSTRAINT folio_control_fk  FOREIGN KEY(folio_control) REFERENCES producto(folio_control)
);



CREATE TABLE forma_pago(
forma_pago_id NUMERIC(10,0) NOT NULL,
banco VARCHAR(15) NOT NULL,
titular VARCHAR(20) NOT NULL,
CONSTRAINT forma_pago_id_pk PRIMARY KEY(forma_pago_id)
);



CREATE TABLE tarjeta(
pago_tarjeta_id NUMERIC(10,0) NOT NULL,
no_tarjeta VARCHAR(16) NOT NULL,
tipo VARCHAR(15) NOT NULL,
anio_vencimiento VARCHAR(4) NOT NULL,
mes_vencimiento VARCHAR(10) NOT NULL,
num_seguridad VARCHAR(5) NOT NULL,
forma_pago_id NUMERIC(10,0) NOT NULL,
CONSTRAINT pago_tarjeta_id_pk PRIMARY KEY(pago_tarjeta_id),
CONSTRAINT forma_pago_id_FK FOREIGN KEY(forma_pago_id) REFERENCES forma_pago(forma_pago_id)
);




CREATE TABLE transferencia(
transferencia_id NUMERIC(10,0) NOT NULL,
clabe VARCHAR(16) NOT NULL,
forma_pago_id NUMERIC(10,0) NOT NULL,
CONSTRAINT transferencia_id_pk PRIMARY KEY(transferencia_id),
CONSTRAINT forma_pago_id_fk FOREIGN KEY(forma_pago_id) REFERENCES forma_pago(forma_pago_id)
);

CREATE TABLE empresa_paqueteria(
empresa_id NUMERIC(10,0) NOT NULL,
nombre VARCHAR(15) NOT NULL,
zona VARCHAR(1) DEFAULT "C",
clave VARCHAR(10) NOT NULL,
CONSTRAINT empresa_id_pk PRIMARY KEY(empresa_id),
CONSTRAINT clave_ck CHECK(zona IN ("A","B","C"))
);



CREATE TABLE cliente(
usuario VARCHAR(20) NOT NULL,
nombre VARCHAR(15) NOT NULL,
apellido_paterno VARCHAR(15) NOT NULL,
apellido_materno VARCHAR(15) NOT NULL,
password VARCHAR(10) NOT NULL,
rfc VARCHAR(13) NULL,
email VARCHAR(25) NOT NULL,
telefono VARCHAR(15) NOT NULL,
direccion1 VARCHAR(74) NOT NULL,
direccion2 VARCHAR(74) NULL,
forma_pago_id NUMERIC(10,0) NOT NULL,
CONSTRAINT usuario_pk PRIMARY KEY(usuario),
CONSTRAINT forma_pago_id_fk FOREIGN KEY(forma_pago_id) REFERENCES forma_pago(forma_pago_id)
);



CREATE TABLE orden_compra(
folio_compra NUMERIC(10) NOT NULL,
paqueteria CHAR(3)  NULL,
streaming CHAR(3) NULL,
usuario VARCHAR(20) NOT NULL,
CONSTRAINT folio_compra_pk PRIMARY KEY(folio_compra),
CONSTRAINT usuario_fk FOREIGN KEY(usuario) REFERENCES cliente(usuario)
);



CREATE TABLE orden_compra_producto(
orden_compra_producto_id NUMERIC(10,0) NOT NULL,
cantidad NUMERIC(4,0) DEFAULT 1,
folio_control VARCHAR(13) NOT NULL, 
folio_compra NUMERIC(10) NOT NULL,
CONSTRAINT orden_compra_producto_id_pk PRIMARY KEY(orden_compra_producto_id),
CONSTRAINT folio_control_fk FOREIGN KEY(folio_control) REFERENCES producto(folio_control),
CONSTRAINT folio_compra_fk FOREIGN KEY(folio_compra) REFERENCES orden_compra(folio_compra)
);



CREATE TABLE factura(
folio_factura VARCHAR(13) NOT NULL,
fecha_generacion DATE NOT NULL,
monto NUMERIC(10,3) NOT NULL,
total_factura NUMERIC(10,3) NOT NULL,
iva NUMERIC(6,3) NOT NULL,
forma_pago_id NUMERIC(10,0) NOT NULL,
folio_compra NUMERIC(10) NOT NULL,
CONSTRAINT folio_factura_pk PRIMARY KEY(folio_factura),
 CONSTRAINT forma_pago_id_fk FOREIGN KEY(forma_pago_id) REFERENCES forma_pago(forma_pago_id),
CONSTRAINT folio_compra_fk FOREIGN KEY(folio_compra) REFERENCES orden_compra(folio_compra)
);



CREATE TABLE paquete(
num_seguimiento NUMERIC(24) NOT NULL,
fecha_envio DATE NOT NULL,
empresa_paqueteria_id NUMERIC(10,0) NOT NULL,
folio_factura VARCHAR(13) NOT NULL,
CONSTRAINT num_seguimiento_pk PRIMARY KEY(num_seguimiento),
CONSTRAINT empresa_paqueteria_id FOREIGN KEY(empresa_paqueteria_id) REFERENCES empresa_paqueteria(empresa_paqueteria_id),
CONSTRAINT folio_factura_fk FOREIGN KEY(folio_factura) REFERENCES factura(folio_factura)
);



CREATE TABLE escala(
escala_id NUMERIC(10,0) NOT NULL,
fecha_llegada DATE NOT NULL,
hora_llegada DATE NOT NULL,
lugar VARCHAR(30) NOT NULL,
CONSTRAINT escala_id_pk PRIMARY KEY(escala_id)
);



CREATE TABLE escala_paquete(
paquete_escalas_id NUMERIC(10,0) NOT NULL,
escala_id NUMERIC(10,0) NULL,
num_seguimiento NUMERIC(24) NOT NULL,
CONSTRAINT paquete_escalas_id_pk PRIMARY KEY(paquete_escalas_id),
CONSTRAINT escala_id_fk FOREIGN KEY(escala_id) REFERENCES escala(escala_id),
CONSTRAINT num_seguimiento_fk FOREIGN KEY(num_seguimiento) REFERENCES paquete(num_seguimiento)
);

