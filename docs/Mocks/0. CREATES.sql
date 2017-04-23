SET AUTOCOMMIT OFF ;

CREATE TABLE GENEROS
(
  ID     NUMBER       NOT NULL,
  NOMBRE VARCHAR(128) NOT NULL,
  IMAGEN VARCHAR(128),
  CONSTRAINT GENEROS_PK PRIMARY KEY (ID)
);

CREATE TABLE CLASIFICACIONES
(
  ID     NUMBER       NOT NULL,
  NOMBRE VARCHAR(128) NOT NULL,
  IMAGEN VARCHAR(128),
  CONSTRAINT CLASIFICACION_PK PRIMARY KEY (ID)
);

CREATE TABLE ACCESIBILIDADES
(
  ID     NUMBER       NOT NULL,
  NOMBRE VARCHAR(128) NOT NULL,
  IMAGEN VARCHAR(128),
  CONSTRAINT ACCESIBILIDAD_PK PRIMARY KEY (ID)
);

CREATE TABLE REQUERIMIENTOS_TECNICOS
(
  ID     NUMBER       NOT NULL,
  NOMBRE VARCHAR(256) NOT NULL,
  IMAGEN VARCHAR(128),
  CONSTRAINT REQUERIMIENTO_TECNICO_PK PRIMARY KEY (ID)
);

CREATE TABLE LOCALIDADES
(
  ID     NUMBER       NOT NULL,
  NOMBRE VARCHAR(128) NOT NULL,
  CONSTRAINT LOCALIDAD_PK PRIMARY KEY (ID)
);

CREATE TABLE FESTIVALES
(
  ID           NUMBER       NOT NULL,
  FECHA_INICIO DATE,
  FECHA_FIN    DATE,
  CIUDAD       VARCHAR2(64) NOT NULL,
  CONSTRAINT FESTIVAL_PK PRIMARY KEY (ID),
  CHECK ( FECHA_FIN > FECHA_INICIO )
);

CREATE TABLE LUGARES
(
  ID                    NUMBER        NOT NULL,
  NOMBRE                VARCHAR2(256) NOT NULL,
  DISPONIBILIDAD_INICIO DATE,
  DISPONIBILIDAD_FIN    DATE,
  ES_ABIERTO            NUMBER,
  TIPO_LUGAR            VARCHAR(64),
  CONSTRAINT LUGAR_PK PRIMARY KEY (ID),
  CHECK ( DISPONIBILIDAD_FIN > DISPONIBILIDAD_INICIO )
);

CREATE TABLE USUARIOS
(
  IDENTIFICACION      NUMBER       NOT NULL,
  TIPO_IDENTIFICACION VARCHAR2(32) NOT NULL,
  EMAIL               VARCHAR2(64) NOT NULL,
  PASSWORD            VARCHAR2(32) NOT NULL,
  NOMBRE              VARCHAR2(64) NOT NULL,
  ROL                 VARCHAR2(32) NOT NULL,
  ID_FESTIVAL         NUMBER       NOT NULL,
  IMAGEN              VARCHAR(128),
  CONSTRAINT USUARIO_PK PRIMARY KEY (IDENTIFICACION, TIPO_IDENTIFICACION),
  CONSTRAINT FK_U_FESTIVAL FOREIGN KEY (ID_FESTIVAL) REFERENCES FESTIVALES (ID),
  CHECK ( ROL IN
          ( 'Usuario Administrador', 'Usuario Organizador', 'Usuario No-Registrado', 'Usuario Registrado', 'Compania De Teatro' ) )
);

CREATE TABLE USUARIOS_REGISTRADOS
(
  ID_USUARIO NUMBER      NOT NULL,
  TIPO_ID    VARCHAR(32) NOT NULL,
  EDAD       NUMBER      NOT NULL,
  CONSTRAINT USUARIO_REGISTRADO_PK PRIMARY KEY (ID_USUARIO, TIPO_ID),
  CONSTRAINT FK_UR_USUARIO FOREIGN KEY (TIPO_ID, ID_USUARIO) REFERENCES USUARIOS (TIPO_IDENTIFICACION, IDENTIFICACION),
  CHECK ( EDAD > 0 )
);

CREATE TABLE COMPANIAS_DE_TEATRO
(
  ID                   NUMBER        NOT NULL,
  TIPO_ID              VARCHAR(32)   NOT NULL,
  NOMBRE_REPRESENTANTE VARCHAR2(64)  NOT NULL,
  PAIS_ORIGEN          VARCHAR2(128) NOT NULL,
  PAGINA_WEB           VARCHAR2(256),
  FECHA_LLEGADA        DATE          NOT NULL,
  FECHA_SALIDA         DATE          NOT NULL,
  CONSTRAINT COMPANIAS_DE_TEATRO_PK PRIMARY KEY (ID, TIPO_ID),
  CONSTRAINT FK_CT_USUARIO FOREIGN KEY (ID, TIPO_ID) REFERENCES USUARIOS (IDENTIFICACION, TIPO_IDENTIFICACION),
  CHECK ( FECHA_SALIDA > FECHA_LLEGADA )
);

CREATE TABLE ESPECTACULOS
(
  ID                NUMBER         NOT NULL,
  NOMBRE            VARCHAR2(256)  NOT NULL,
  DURACION          NUMBER         NOT NULL,
  IDIOMA            VARCHAR2(128)  NOT NULL,
  COSTO_REALIZACION NUMBER         NOT NULL,
  DESCRIPCION       VARCHAR2(2048) NOT NULL,
  ID_FESTIVAL       NUMBER         NOT NULL,
  ID_CLASIFICACION  NUMBER         NOT NULL,
  CONSTRAINT ESPECTACULOS_PK PRIMARY KEY (ID),
  CONSTRAINT FK_E_FESTIVAL FOREIGN KEY (ID_FESTIVAL) REFERENCES FESTIVALES (ID),
  CONSTRAINT FK_E_CLASIFICACION FOREIGN KEY (ID_CLASIFICACION) REFERENCES CLASIFICACIONES (ID),
  CHECK ( COSTO_REALIZACION > 0 ),
  CHECK ( DURACION > 0 )
);

CREATE TABLE FUNCIONES
(
  FECHA          DATE   NOT NULL,
  ID_LUGAR       NUMBER NOT NULL,
  ID_ESPECTACULO NUMBER NOT NULL,
  SE_REALIZA     NUMBER,
  CONSTRAINT FUNCION_PK PRIMARY KEY (ID_LUGAR, FECHA),
  CONSTRAINT FK_F_ESPECTACULO FOREIGN KEY (ID_ESPECTACULO) REFERENCES ESPECTACULOS (ID),
  CONSTRAINT FK_F_LUGAR FOREIGN KEY (ID_LUGAR) REFERENCES LUGARES (ID)
  -- Realizar Check de rango de fechas
);

CREATE TABLE LUGAR_LOCALIDAD
(
  ID_LUGAR     NUMBER NOT NULL,
  ID_LOCALIDAD NUMBER NOT NULL,
  ES_NUMERADO  NUMBER NOT NULL,
  CAPACIDAD    NUMBER NOT NULL,
  CONSTRAINT LUGAR_LOCALIDAD_PK PRIMARY KEY (ID_LUGAR, ID_LOCALIDAD),
  CONSTRAINT FK_LL_LUGAR FOREIGN KEY (ID_LUGAR) REFERENCES LUGARES (ID),
  CONSTRAINT FK_LL_LOCALIDAD FOREIGN KEY (ID_LOCALIDAD) REFERENCES LOCALIDADES (ID),
  CHECK ( CAPACIDAD >= 0 )
);

CREATE TABLE SILLAS
(
  NUM_FILA     NUMBER(3, 0) NOT NULL,
  NUM_SILLA    NUMBER(3, 0) NOT NULL,
  ID_LOCALIDAD NUMBER       NOT NULL,
  ID_LUGAR     NUMBER       NOT NULL,
  CONSTRAINT SILLA_PK PRIMARY KEY (NUM_FILA, NUM_SILLA, ID_LOCALIDAD, ID_LUGAR),
  CONSTRAINT FK_S_LUGAR_LOCALIDAD FOREIGN KEY (ID_LOCALIDAD, ID_LUGAR) REFERENCES LUGAR_LOCALIDAD (ID_LOCALIDAD, ID_LUGAR),
  CHECK ( NUM_FILA >= 0 ),
  CHECK ( NUM_SILLA >= 0 )
);

CREATE TABLE COSTO_LOCALIDAD
(
  FECHA        DATE   NOT NULL,
  ID_LUGAR     NUMBER NOT NULL,
  ID_LOCALIDAD NUMBER NOT NULL,
  COSTO        NUMBER NOT NULL,
  CONSTRAINT COSTO_LOCALIDAD_PK PRIMARY KEY (FECHA, ID_LUGAR, ID_LOCALIDAD),
  CONSTRAINT FK_CL_FUNCION FOREIGN KEY (FECHA, ID_LUGAR) REFERENCES FUNCIONES (FECHA, ID_LUGAR),
  CONSTRAINT FK_CL_LL FOREIGN KEY (ID_LUGAR, ID_LOCALIDAD) REFERENCES LUGAR_LOCALIDAD (ID_LUGAR, ID_LOCALIDAD),
  CHECK ( COSTO >= 0 )
);

CREATE TABLE BOLETAS
(
  NUM_BOLETA   NUMBER      NOT NULL,
  NUM_SILLA    NUMBER      NOT NULL,
  NUM_FILA     NUMBER      NOT NULL,
  ID_LOCALIDAD NUMBER      NOT NULL,
  ID_LUGAR     NUMBER      NOT NULL,
  FECHA        DATE        NOT NULL,
  ID_USUARIO   NUMBER      NOT NULL,
  ID_TIPO      VARCHAR(16) NOT NULL,
  CONSTRAINT BOLETA_PK PRIMARY KEY (NUM_BOLETA),
  CONSTRAINT FK_B_FUNCION_LOCALIDAD FOREIGN KEY (ID_LUGAR, FECHA, ID_LOCALIDAD) REFERENCES COSTO_LOCALIDAD (ID_LUGAR, FECHA, ID_LOCALIDAD),
  CONSTRAINT FK_B_SILLA FOREIGN KEY (NUM_SILLA, NUM_FILA, ID_LUGAR, ID_LOCALIDAD) REFERENCES SILLAS (NUM_SILLA, NUM_FILA, ID_LUGAR, ID_LOCALIDAD),
  CONSTRAINT FK_B_USUARIO FOREIGN KEY (ID_USUARIO, ID_TIPO) REFERENCES USUARIOS (IDENTIFICACION, TIPO_IDENTIFICACION)
);

CREATE TABLE OFRECE
(
  ID_COMPANIA_DE_TEATRO NUMBER      NOT NULL,
  TIPO_ID               VARCHAR(16) NOT NULL,
  ID_ESPECTACULO        NUMBER      NOT NULL,
  CONSTRAINT OFRECE_PK PRIMARY KEY (ID_COMPANIA_DE_TEATRO, ID_ESPECTACULO),
  CONSTRAINT FK_O_COMPANIAS_DE_TEATRO FOREIGN KEY (ID_COMPANIA_DE_TEATRO, TIPO_ID) REFERENCES COMPANIAS_DE_TEATRO (ID, TIPO_ID),
  CONSTRAINT FK_O_ESPECTACULO FOREIGN KEY (ID_ESPECTACULO) REFERENCES ESPECTACULOS (ID)
);

CREATE TABLE ESPECTACULO_GENEROS
(
  ID_ESPECTACULO NUMBER NOT NULL,
  ID_GENERO      NUMBER NOT NULL,
  CONSTRAINT ESPECTACULO_GENEROS_PK PRIMARY KEY (ID_ESPECTACULO, ID_GENERO),
  CONSTRAINT FK_EC_GENERO FOREIGN KEY (ID_GENERO) REFERENCES GENEROS (ID),
  CONSTRAINT FK_EC_ESPECTACULO FOREIGN KEY (ID_ESPECTACULO) REFERENCES ESPECTACULOS (ID)
);

CREATE TABLE ESPECTACULO_REQUERIMIENTO
(
  ID_ESPECTACULO   NUMBER NOT NULL,
  ID_REQUERIMIENTO NUMBER NOT NULL,
  CONSTRAINT ESPECTACULO_REQ_TECNICOS_PK PRIMARY KEY (ID_ESPECTACULO, ID_REQUERIMIENTO),
  CONSTRAINT FK_ERT_REQUERIMIENTO_TECNICO FOREIGN KEY (ID_REQUERIMIENTO) REFERENCES REQUERIMIENTOS_TECNICOS (ID),
  CONSTRAINT FK_ERT_ESPECTACULO FOREIGN KEY (ID_ESPECTACULO) REFERENCES ESPECTACULOS (ID)
);

CREATE TABLE LUGAR_ACCESIBILIDAD
(
  ID_LUGAR         NUMBER NOT NULL,
  ID_ACCESIBILIDAD NUMBER NOT NULL,
  CONSTRAINT LUGAR_ACCESIBILIDAD_PK PRIMARY KEY (ID_LUGAR, ID_ACCESIBILIDAD),
  CONSTRAINT FK_LA_LUGAR FOREIGN KEY (ID_LUGAR) REFERENCES LUGARES (ID),
  CONSTRAINT FK_LA_ACCESIBILIDAD FOREIGN KEY (ID_ACCESIBILIDAD) REFERENCES ACCESIBILIDADES (ID)
);

CREATE TABLE LUGAR_REQUERIMIENTO
(
  ID_LUGAR         NUMBER NOT NULL,
  ID_REQUERIMIENTO NUMBER NOT NULL,
  CONSTRAINT LUGAR_REQ_TECNICOS_PK PRIMARY KEY (ID_LUGAR, ID_REQUERIMIENTO),
  CONSTRAINT FK_LRT_REQUERIMIENTO_TECNICO FOREIGN KEY (ID_REQUERIMIENTO) REFERENCES REQUERIMIENTOS_TECNICOS (ID),
  CONSTRAINT FK_LRT_LUGAR FOREIGN KEY (ID_LUGAR) REFERENCES LUGARES (ID)
);

CREATE TABLE PREFERENCIA_GENEROS
(
  ID_USUARIO NUMBER      NOT NULL,
  ID_TIPO    VARCHAR(16) NOT NULL,
  ID_GENERO  NUMBER      NOT NULL,
  CONSTRAINT PREFERENCIA_GENEROS_PK PRIMARY KEY (ID_USUARIO, ID_TIPO, ID_GENERO),
  CONSTRAINT FK_PG_CLIENTE_REGISTRADO FOREIGN KEY (ID_USUARIO, ID_TIPO) REFERENCES USUARIOS_REGISTRADOS (ID_USUARIO, TIPO_ID),
  CONSTRAINT FK_PG_GENERO FOREIGN KEY (ID_GENERO) REFERENCES GENEROS (ID)
);

CREATE TABLE PREFERENCIA_LUGARES
(
  ID_USUARIO NUMBER      NOT NULL,
  ID_TIPO    VARCHAR(16) NOT NULL,
  ID_LUGAR   NUMBER      NOT NULL,
  CONSTRAINT PREFERENCIA_LUGARES_PK PRIMARY KEY (ID_USUARIO, ID_TIPO, ID_LUGAR),
  CONSTRAINT FK_PL_CLIENTE_REGISTRADO FOREIGN KEY (ID_USUARIO, ID_TIPO) REFERENCES USUARIOS_REGISTRADOS (ID_USUARIO, TIPO_ID),
  CONSTRAINT FK_PL_LUGAR FOREIGN KEY (ID_LUGAR) REFERENCES LUGARES (ID)
);

CREATE TABLE ABONO
(
  ID_FESTIVAL NUMBER      NOT NULL,
  ID_USUARIO  NUMBER      NOT NULL,
  TIPO_ID     VARCHAR(10) NOT NULL,
  DESCUENTO   FLOAT       NOT NULL,
  CONSTRAINT ABONO_PK PRIMARY KEY (ID_FESTIVAL, ID_USUARIO, TIPO_ID),
  CONSTRAINT FK_A_FESTIVAL FOREIGN KEY (ID_FESTIVAL) REFERENCES FESTIVALES (ID),
  CONSTRAINT FK_A_USUARIO FOREIGN KEY (ID_USUARIO, TIPO_ID) REFERENCES USUARIOS_REGISTRADOS (ID_USUARIO, TIPO_ID)
);

CREATE TABLE ABONO_FUNCION
(
  ID_FESTIVAL  NUMBER      NOT NULL,
  ID_USUARIO   NUMBER      NOT NULL,
  TIPO_ID      VARCHAR(10) NOT NULL,
  FECHA        DATE        NOT NULL,
  ID_LUGAR     NUMBER      NOT NULL,
  ID_LOCALIDAD NUMBER      NOT NULL,
  CONSTRAINT ABONO_FUNCION_PK PRIMARY KEY (ID_FESTIVAL, ID_USUARIO, TIPO_ID, FECHA, ID_LUGAR),
  CONSTRAINT FK_AF_FESTIVAL FOREIGN KEY (ID_FESTIVAL, ID_USUARIO, TIPO_ID) REFERENCES ABONO (ID_FESTIVAL, ID_USUARIO, TIPO_ID),
  CONSTRAINT FK_AF_FUNCION FOREIGN KEY (FECHA, ID_LUGAR, ID_LOCALIDAD) REFERENCES COSTO_LOCALIDAD (FECHA, ID_LUGAR, ID_LOCALIDAD)
);

COMMIT;