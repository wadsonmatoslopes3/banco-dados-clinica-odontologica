CREATE DATABASE IF NOT EXISTS clinica_odontologica
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE clinica_odontologica;

CREATE TABLE PACIENTE (
    id_paciente        INT AUTO_INCREMENT,
    nome               VARCHAR(100) NOT NULL,
    cpf                CHAR(11)     NOT NULL,
    telefone           VARCHAR(15),
    data_nascimento    DATE         NOT NULL,
    historico_alergias TEXT,
    CONSTRAINT pk_paciente PRIMARY KEY (id_paciente),
    CONSTRAINT uq_paciente_cpf UNIQUE (cpf)
);

CREATE TABLE FUNCIONARIO (
    id_funcionario INT AUTO_INCREMENT,
    nome           VARCHAR(100) NOT NULL,
    cpf            CHAR(11)     NOT NULL,
    cargo          VARCHAR(50)  NOT NULL,
    telefone       VARCHAR(15),
    CONSTRAINT pk_funcionario PRIMARY KEY (id_funcionario),
    CONSTRAINT uq_funcionario_cpf UNIQUE (cpf),
    CONSTRAINT ck_funcionario_cargo CHECK (cargo IN ('Recepcionista', 'Auxiliar', 'Técnico em Saúde Bucal'))
);

CREATE TABLE TRIAGEM (
    id_triagem       INT AUTO_INCREMENT,
    data_hora        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    pressao_arterial VARCHAR(10),
    queixa_principal TEXT         NOT NULL,
    nivel_urgencia   VARCHAR(10)  NOT NULL,
    id_paciente      INT          NOT NULL,
    id_funcionario   INT          NOT NULL,
    CONSTRAINT pk_triagem PRIMARY KEY (id_triagem),
    CONSTRAINT fk_triagem_paciente FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente),
    CONSTRAINT fk_triagem_funcionario FOREIGN KEY (id_funcionario)
        REFERENCES FUNCIONARIO (id_funcionario),
    CONSTRAINT ck_triagem_urgencia CHECK (nivel_urgencia IN ('Baixa', 'Média', 'Alta', 'Emergência'))
);

INSERT INTO clinica_odontologica.PACIENTE (nome, cpf, telefone, data_nascimento, historico_alergias)
VALUES ('Maria Souza', '12345678901', '31999998888', '1990-05-14', 'Alergia a penicilina');

INSERT INTO clinica_odontologica.FUNCIONARIO (nome, cpf, cargo, telefone)
VALUES ('Carlos Lima', '98765432100', 'Recepcionista', '31988887777');

INSERT INTO clinica_odontologica.TRIAGEM(pressao_arterial, queixa_principal, nivel_urgencia, id_paciente, id_funcionario)
VALUES ('120/80', 'Dor forte no dente molar inferior direito', 'Alta', 1, 1);

SELECT * FROM clinica_odontologica.TRIAGEM;
