--CREATE DATABASE Polizia
CREATE TABLE AgenteDiPolizia(
IdAgente INT IDENTITY(1,1) NOT NULL,
Nome NVARCHAR(30) NOT NULL,
Cognome NVARCHAR(50) NOT NULL,
CF NVARCHAR(16) UNIQUE NOT NULL,
DataDiNascita DATE NOT NULL,
AnniServizio INT,
CONSTRAINT Pk_Agente PRIMARY KEY (IdAgente),
CONSTRAINT CheckAge CHECK ((YEAR(GETDATE()) - YEAR(DataDiNascita))>=18)
--(datediff(YY,GETDATE(),DataDiNascita)>=18)
);

CREATE TABLE AreaMetropolitana(
IdArea INT IDENTITY(1,1) NOT NULL,
CodArea NVARCHAR(5) NOT NULL,
AltoRischio INT NOT NULL
CONSTRAINT Pk_Area PRIMARY KEY (IdArea)
CONSTRAINT CheckRischio CHECK (AltoRischio = '1' OR AltoRischio = '0')
);

CREATE TABLE AgenteArea(
IdAgente INT FOREIGN KEY REFERENCES AgenteDiPolizia(IdAgente),
IdArea INT FOREIGN KEY REFERENCES AreaMetropolitana(IdArea)
CONSTRAINT Pk_AgenteArea PRIMARY KEY (IdAgente, IdArea)
);

INSERT INTO AgenteDiPolizia VALUES ('Ciccio', 'Pasticcio', 'CIP97XXX','19971212',3);
INSERT INTO AgenteDiPolizia VALUES ('Fran', 'Cesca', 'FCE82YYY','19821110',10);
INSERT INTO AgenteDiPolizia VALUES ('Mario', 'Marione', 'MRM89XXX','19890201',11);
INSERT INTO AgenteDiPolizia VALUES ('Signor', 'Commissario', 'SGR97XXX','19970912',1);
--Questa sotto dà errore
--INSERT INTO AgenteDiPolizia VALUES ('c', 'd', 'CIP09XXX','20091212',3);

INSERT INTO AreaMetropolitana VALUES ('s8899',0);
INSERT INTO AreaMetropolitana VALUES ('s7799',1);
INSERT INTO AreaMetropolitana VALUES ('s6699',0);
INSERT INTO AreaMetropolitana VALUES ('s5599',1);
INSERT INTO AreaMetropolitana VALUES ('s4499',1);
INSERT INTO AreaMetropolitana VALUES ('s3399',1);

INSERT INTO AgenteArea VALUES (1,1);
INSERT INTO AgenteArea VALUES (3,2);
INSERT INTO AgenteArea VALUES (4,3);
INSERT INTO AgenteArea VALUES (1,4);
INSERT INTO AgenteArea VALUES (3,5);
INSERT INTO AgenteArea VALUES (3,6);
INSERT INTO AgenteArea VALUES (5,6);

--Esercitazione--

--1. visualizzare l'elenco degli agenti che lavorano in "aree ad alto rischio" e hanno meno di 3 anni di servizio

SELECT a.*
FROM AgenteDiPolizia a JOIN AgenteArea aa ON aa.IdAgente = a.IdAgente JOIN AreaMetropolitana ar ON ar.IdArea = aa.IdArea
WHERE ar.AltoRischio = '1' AND a.AnniServizio < 3

--2. visualizzare il numero di agenti assegnati per ogni area geografica (numero agenti e codice area)
SELECT ar.CodArea, COUNT(a.IdAgente) AS NumeroAgentiAssegnati
FROM AreaMetropolitana ar JOIN  AgenteArea aa ON ar.IdArea = aa.IdArea JOIN AgenteDiPolizia a ON aa.IdAgente = a.IdAgente
GROUP BY(ar.CodArea)
ORDER BY(NumeroAgentiAssegnati) 
