CREATE TABLE clinica_odontologica.DENTISTA (
    id_dentista   INT AUTO_INCREMENT,
    nome          VARCHAR(100) NOT NULL,
    cro           VARCHAR(20)  NOT NULL,
    especialidade VARCHAR(50),
    telefone      VARCHAR(15),
    CONSTRAINT pk_dentista PRIMARY KEY (id_dentista),
    CONSTRAINT uq_dentista_cro UNIQUE (cro)
);

CREATE TABLE clinica_odontologica.PROCEDIMENTO (
    id_procedimento         INT AUTO_INCREMENT,
    nome_procedimento       VARCHAR(100)  NOT NULL,
    valor_base              DECIMAL(10,2) NOT NULL,
    tempo_estimado_minutos  INT           NOT NULL,
    CONSTRAINT pk_procedimento PRIMARY KEY (id_procedimento),
    CONSTRAINT ck_procedimento_valor CHECK (valor_base >= 0),
    CONSTRAINT ck_procedimento_tempo CHECK (tempo_estimado_minutos > 0)
);

CREATE TABLE clinica_odontologica.CONSULTA (
    id_consulta         INT AUTO_INCREMENT,
    data_hora           DATETIME    NOT NULL,
    status              VARCHAR(10) NOT NULL DEFAULT 'Agendada',
    observacoes_clinicas TEXT,
    id_triagem          INT         NOT NULL,
    id_dentista         INT         NOT NULL,
    CONSTRAINT pk_consulta PRIMARY KEY (id_consulta),
    CONSTRAINT uq_consulta_triagem UNIQUE (id_triagem),
    CONSTRAINT fk_consulta_triagem FOREIGN KEY (id_triagem)
        REFERENCES clinica_odontologica.TRIAGEM (id_triagem),
    CONSTRAINT fk_consulta_dentista FOREIGN KEY (id_dentista)
        REFERENCES clinica_odontologica.DENTISTA (id_dentista),
    CONSTRAINT ck_consulta_status CHECK (status IN ('Agendada', 'Realizada', 'Cancelada'))
);

CREATE TABLE clinica_odontologica.ITEM_CONSULTA (
    id_item         INT AUTO_INCREMENT,
    id_consulta     INT           NOT NULL,
    id_procedimento INT           NOT NULL,
    dente_regiao    VARCHAR(50),
    valor_cobrado   DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_item_consulta PRIMARY KEY (id_item),
    CONSTRAINT fk_item_consulta FOREIGN KEY (id_consulta)
        REFERENCES clinica_odontologica.CONSULTA (id_consulta),
    CONSTRAINT fk_item_procedimento FOREIGN KEY (id_procedimento)
        REFERENCES clinica_odontologica.PROCEDIMENTO (id_procedimento),
    CONSTRAINT ck_item_valor CHECK (valor_cobrado >= 0)
);

INSERT INTO clinica_odontologica.DENTISTA (nome, cro, especialidade, telefone)
VALUES ('Dra. Ana Ribeiro', 'CRO-MG 12345', 'Clínico Geral', '31977776666');

INSERT INTO clinica_odontologica.PROCEDIMENTO (nome_procedimento, valor_base, tempo_estimado_minutos)
VALUES ('Restauração em resina', 180.00, 40),
       ('Limpeza e profilaxia', 120.00, 30);

INSERT INTO clinica_odontologica.CONSULTA (data_hora, status, observacoes_clinicas, id_triagem, id_dentista)
VALUES (NOW(), 'Realizada', 'Cárie no molar inferior direito; limpeza realizada na mesma sessão.', 1, 1);

INSERT INTO clinica_odontologica.ITEM_CONSULTA (id_consulta, id_procedimento, dente_regiao, valor_cobrado)
VALUES (1, 1, 'Dente 46 (molar inferior direito)', 180.00),
       (1, 2, 'Arcada completa', 120.00);
   SELECT p.nome AS paciente, f.nome AS funcionario_triagem, t.queixa_principal,
       d.nome AS dentista, c.status, pr.nome_procedimento,
       i.dente_regiao, i.valor_cobrado
FROM clinica_odontologica.ITEM_CONSULTA i
JOIN clinica_odontologica.CONSULTA c      ON c.id_consulta = i.id_consulta
JOIN clinica_odontologica.PROCEDIMENTO pr ON pr.id_procedimento = i.id_procedimento
JOIN clinica_odontologica.DENTISTA d      ON d.id_dentista = c.id_dentista
JOIN clinica_odontologica.TRIAGEM t       ON t.id_triagem = c.id_triagem
JOIN clinica_odontologica.PACIENTE p      ON p.id_paciente = t.id_paciente
JOIN clinica_odontologica.FUNCIONARIO f   ON f.id_funcionario = t.id_funcionario;    