-- object: temporal | type: DATABASE --
DROP DATABASE IF EXISTS temporal;
CREATE DATABASE temporal;
-- ddl-end --


SET check_function_bodies = false;
-- ddl-end --

-- object: public.producte | type: TABLE --
-- DROP TABLE IF EXISTS public.producte CASCADE;
CREATE TABLE public.producte (
	id serial NOT NULL,
	nom text,
	familia text,
	descripcio text,
	ean text,
	CONSTRAINT pk_producte PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON COLUMN public.producte.familia IS E'A què pertany?';
-- ddl-end --
COMMENT ON COLUMN public.producte.descripcio IS E'Què és';
-- ddl-end --
COMMENT ON COLUMN public.producte.ean IS E'Codi de barres';
-- ddl-end --
ALTER TABLE public.producte OWNER TO jordipsql;
-- ddl-end --

-- object: public.beneficiari | type: TABLE --
-- DROP TABLE IF EXISTS public.beneficiari CASCADE;
CREATE TABLE public.beneficiari (
	id serial NOT NULL,
	comerc text,
	intern smallint,
	CONSTRAINT pk_beneficiari PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON COLUMN public.beneficiari.intern IS E'Clau forània per identificar quan es faci una transacció entre un compte meu a un altre compte meu';
-- ddl-end --
ALTER TABLE public.beneficiari OWNER TO jordipsql;
-- ddl-end --

-- object: public.categoria | type: TABLE --
-- DROP TABLE IF EXISTS public.categoria CASCADE;
CREATE TABLE public.categoria (
	id serial NOT NULL,
	nom text,
	subcategoria integer,
	CONSTRAINT pk_categoria PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public.categoria OWNER TO jordipsql;
-- ddl-end --

-- object: public.comptes | type: TABLE --
-- DROP TABLE IF EXISTS public.comptes CASCADE;
CREATE TABLE public.comptes (
	id serial NOT NULL,
	banc text,
	import numeric(10,2),
	CONSTRAINT pk_comptes PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON COLUMN public.comptes.import IS E'Utilitar NUMERIC degut a que guardarem valors en coma.\nLENGTH es la longitud total que tindrà el valor numèric que guardarem.\nPRECISSION són els decimals que hi guardarem';
-- ddl-end --
ALTER TABLE public.comptes OWNER TO jordipsql;
-- ddl-end --

-- object: public.subcategoria | type: TABLE --
-- DROP TABLE IF EXISTS public.subcategoria CASCADE;
CREATE TABLE public.subcategoria (
	id serial NOT NULL,
	nom text,
	CONSTRAINT pk_subcategoria PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON COLUMN public.subcategoria.nom IS E'Quina subcategoria és:\n\n- Menjar -> Sa\n- Menjar -> Queviures\n- Cotxe -> Peatge\n- Cotxe -> Mecànic\n- Transport -> TMB';
-- ddl-end --
ALTER TABLE public.subcategoria OWNER TO jordipsql;
-- ddl-end --

-- object: public.operacions | type: TABLE --
-- DROP TABLE IF EXISTS public.operacions CASCADE;
CREATE TABLE public.operacions (
	id serial NOT NULL,
	data date,
	fkey_compte integer,
	fkey_beneficiari integer,
	import numeric(10,2),
	fkey_cistell integer,
	fkey_categoria integer,
	CONSTRAINT pk_operacions PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON COLUMN public.operacions.data IS E'Quan s_ha realitzat la operació';
-- ddl-end --
COMMENT ON COLUMN public.operacions.fkey_compte IS E'Què s_ha utlitzat per fer el pagament';
-- ddl-end --
COMMENT ON COLUMN public.operacions.fkey_beneficiari IS E'A on s_ha pagat';
-- ddl-end --
COMMENT ON COLUMN public.operacions.fkey_cistell IS E'La compra';
-- ddl-end --
ALTER TABLE public.operacions OWNER TO jordipsql;
-- ddl-end --

-- object: public.cistell_compra | type: TABLE --
-- DROP TABLE IF EXISTS public.cistell_compra CASCADE;
CREATE TABLE public.cistell_compra (
	id serial NOT NULL,
	fkey_quantitat_1 integer,
	fkey_quantitat_2 integer,
	fkey_quantitat_3 integer,
	fkey_quantitat_4 integer,
	fkey_quantitat_5 integer,
	fkey_quantitat_6 integer,
	fkey_quantitat_7 integer,
	fkey_quantitat_8 integer,
	fkey_quantitat_9 integer,
	fkey_quantitat_10 integer,
	fkey_quantitat_11 integer,
	fkey_quantitat_12 integer,
	fkey_quantitat_13 integer,
	fkey_quantitat_14 integer,
	fkey_quantitat_15 integer,
	fkey_quantitat_16 integer,
	fkey_quantitat_17 integer,
	fkey_quantitat_18 integer,
	fkey_quantitat_19 integer,
	fkey_quantitat_20 integer,
	fkey_quantitat_21 integer,
	fkey_quantitat_22 integer,
	fkey_quantitat_23 integer,
	fkey_quantitat_24 integer,
	fkey_quantitat_25 integer,
	CONSTRAINT pk_cistell PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public.cistell_compra OWNER TO jordipsql;
-- ddl-end --

-- object: public.quantitat | type: TABLE --
-- DROP TABLE IF EXISTS public.quantitat CASCADE;
CREATE TABLE public.quantitat (
	id serial NOT NULL,
	quantitat integer,
	fkey_historicpreus integer,
	pes numeric(5,3),
	CONSTRAINT pk_quantitat PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public.quantitat OWNER TO jordipsql;
COMMENT ON COLUMN public.quantitat.pes IS E'Pes de la carn al Bon Area. El pes a historicpreus és a €/Kg';
-- ddl-end --

-- object: public.historicpreus | type: TABLE --
-- DROP TABLE IF EXISTS public.historicpreus CASCADE;
CREATE TABLE public.historicpreus (
	id serial NOT NULL,
	pvp numeric(10,2),
	data date,
	ofertes text,
	fkey_producte integer,
	fkey_beneficiari integer,
	stock boolean DEFAULT '1',
	CONSTRAINT pk_historicpreus PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON TABLE public.historicpreus IS E'Històric preus pvp';
-- ddl-end --
COMMENT ON COLUMN public.historicpreus.pvp IS E'Preu Venta al Públic';
-- ddl-end --
COMMENT ON COLUMN public.historicpreus.data IS E'Quan disponia d_aquest preu';
-- ddl-end --
COMMENT ON COLUMN public.historicpreus.fkey_producte IS E'Clau forània al producte';
-- ddl-end --
COMMENT ON COLUMN public.historicpreus.fkey_beneficiari IS E'Cau forania comerç';
-- ddl-end --
ALTER TABLE public.historicpreus OWNER TO jordipsql;
-- ddl-end --
ALTER TABLE public.historicpreus ENABLE ROW LEVEL SECURITY;
-- ddl-end --

-- object: public.troba_id_quantitat | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.troba_id_quantitat(integer,integer) CASCADE;
CREATE OR REPLACE FUNCTION public.troba_id_quantitat (IN variable1 integer, IN variable2 integer)
	RETURNS integer
	LANGUAGE plpgsql
	STABLE
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
  DECLARE
    resultat INTEGER;
  BEGIN
    SELECT id INTO resultat FROM quantitat WHERE quantitat = variable1 AND fkey_historicpreus = variable2;
    IF resultat IS NOT NULL THEN
      RETURN resultat;
    ELSE
      resultat := 0;
      RETURN resultat;
    END IF;
  END;
$$;
-- ddl-end --
ALTER FUNCTION public.troba_id_quantitat(integer,integer) OWNER TO jordipsql;
-- ddl-end --

-- object: public.troba_id_cistell | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.troba_id_cistell(integer, VARIADIC integer[]) CASCADE;
CREATE OR REPLACE FUNCTION public.troba_id_cistell (OUT resultat integer, VARIADIC variable integer[])
	RETURNS integer
	LANGUAGE plpgsql
	VOLATILE
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
DECLARE
    nou INTEGER[];
    longitud INTEGER;
  BEGIN
    nou:=sort(variable);
    longitud:=(SELECT array_length(variable,1));
    IF longitud = 1 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 IS NULL AND fkey_quantitat_3 IS NULL AND fkey_quantitat_4 IS NULL AND fkey_quantitat_5 IS NULL AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 2 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 IS NULL AND fkey_quantitat_4 IS NULL AND fkey_quantitat_5 IS NULL AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 3 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 IS NULL AND fkey_quantitat_5 IS NULL AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 4 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 IS NULL AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 5 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 6 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 7 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 8 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_8 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 9 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 10 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 11 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 12 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 13 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 14 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 = nou[14] AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 15 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 = nou[14] AND fkey_quantitat_15 = nou[15] AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 16 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 = nou[14] AND fkey_quantitat_15 = nou[15] AND fkey_quantitat_16 = nou[16] AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 17 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 = nou[14] AND fkey_quantitat_15 = nou[15] AND fkey_quantitat_16 = nou[16] AND fkey_quantitat_17 = nou[17] AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 18 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 = nou[14] AND fkey_quantitat_15 = nou[15] AND fkey_quantitat_16 = nou[16] AND fkey_quantitat_17 = nou[17] AND fkey_quantitat_18 = nou[18] AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 19 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 = nou[14] AND fkey_quantitat_15 = nou[15] AND fkey_quantitat_16 = nou[16] AND fkey_quantitat_17 = nou[17] AND fkey_quantitat_18 = nou[18] AND fkey_quantitat_19 = nou[19] AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 20 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 = nou[14] AND fkey_quantitat_15 = nou[15] AND fkey_quantitat_16 = nou[16] AND fkey_quantitat_17 = nou[17] AND fkey_quantitat_18 = nou[18] AND fkey_quantitat_19 = nou[19] AND fkey_quantitat_20 = nou[20] AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 21 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 = nou[14] AND fkey_quantitat_15 = nou[15] AND fkey_quantitat_16 = nou[16] AND fkey_quantitat_17 = nou[17] AND fkey_quantitat_18 = nou[18] AND fkey_quantitat_19 = nou[19] AND fkey_quantitat_20 = nou[20] AND fkey_quantitat_21 = nou[21] AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 22 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 = nou[14] AND fkey_quantitat_15 = nou[15] AND fkey_quantitat_16 = nou[16] AND fkey_quantitat_17 = nou[17] AND fkey_quantitat_18 = nou[18] AND fkey_quantitat_19 = nou[19] AND fkey_quantitat_20 = nou[20] AND fkey_quantitat_21 = nou[21] AND fkey_quantitat_22 = nou[22] AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 23 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 = nou[14] AND fkey_quantitat_15 = nou[15] AND fkey_quantitat_16 = nou[16] AND fkey_quantitat_17 = nou[17] AND fkey_quantitat_18 = nou[18] AND fkey_quantitat_19 = nou[19] AND fkey_quantitat_20 = nou[20] AND fkey_quantitat_21 = nou[21] AND fkey_quantitat_22 = nou[22] AND fkey_quantitat_23 = nou[23] AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 24 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 = nou[14] AND fkey_quantitat_15 = nou[15] AND fkey_quantitat_16 = nou[16] AND fkey_quantitat_17 = nou[17] AND fkey_quantitat_18 = nou[18] AND fkey_quantitat_19 = nou[19] AND fkey_quantitat_20 = nou[20] AND fkey_quantitat_21 = nou[21] AND fkey_quantitat_22 = nou[22] AND fkey_quantitat_23 = nou[23] AND fkey_quantitat_24 = nou[24] AND fkey_quantitat_25 IS NULL);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    ELSIF longitud = 25 THEN resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = nou[1] AND fkey_quantitat_2 = nou[2] AND fkey_quantitat_3 = nou[3] AND fkey_quantitat_4 = nou[4] AND fkey_quantitat_5 = nou[5] AND fkey_quantitat_6 = nou[6] AND fkey_quantitat_7 = nou[7] AND fkey_quantitat_8 = nou[8] AND fkey_quantitat_9 = nou[9] AND fkey_quantitat_10 = nou[10] AND fkey_quantitat_11 = nou[11] AND fkey_quantitat_12 = nou[12] AND fkey_quantitat_13 = nou[13] AND fkey_quantitat_14 = nou[14] AND fkey_quantitat_15 = nou[15] AND fkey_quantitat_16 = nou[16] AND fkey_quantitat_17 = nou[17] AND fkey_quantitat_18 = nou[18] AND fkey_quantitat_19 = nou[19] AND fkey_quantitat_20 = nou[20] AND fkey_quantitat_21 = nou[21] AND fkey_quantitat_22 = nou[22] AND fkey_quantitat_23 = nou[23] AND fkey_quantitat_24 = nou[24] AND fkey_quantitat_25 = nou[25]);
      IF resultat IS NULL THEN
        resultat := 0;
      END IF;
    END IF;
  END;
$$;
-- ddl-end --
ALTER FUNCTION public.troba_id_cistell(integer, VARIADIC integer[]) OWNER TO jordipsql;
-- ddl-end --

-- object: public.crea_quantitat_normal | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.crea_quantitat_normal(integer,integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION public.crea_quantitat_normal (IN quant integer, IN fkey integer, OUT identificador integer)
	RETURNS integer
	LANGUAGE plpgsql
	VOLATILE
	RETURNS NULL ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
--DECLARE
  --identificador INTEGER;
BEGIN
    INSERT INTO quantitat (quantitat, fkey_historicpreus) SELECT quant,fkey WHERE NOT EXISTS (SELECT * FROM quantitat WHERE quantitat = quant AND fkey_historicpreus = fkey );
    identificador:=(SELECT id FROM quantitat WHERE quantitat = quant AND fkey_historicpreus = fkey);
    RETURN identificador;
$$;
-- ddl-end --
ALTER FUNCTION public.crea_quantitat_normal(integer,integer) OWNER TO jordipsql;
-- ddl-end --

-- object: public.url_sorli | type: TABLE --
-- DROP TABLE IF EXISTS public.url_sorli CASCADE;
CREATE TABLE public.url_sorli (
	id serial NOT NULL,
	fkey_producte integer,
	url text,
	CONSTRAINT id_sorli PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON COLUMN public.url_sorli.url IS E'url on està el producte';
-- ddl-end --
ALTER TABLE public.url_sorli OWNER TO jordipsql;
-- ddl-end --

-- object: public.url_condis | type: TABLE --
-- DROP TABLE IF EXISTS public.url_condis CASCADE;
CREATE TABLE public.url_condis (
	id serial NOT NULL,
	fkey_producte integer,
	url text,
	CONSTRAINT id_2 PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON COLUMN public.url_condis.url IS E'url on està guardat el producte';
-- ddl-end --
ALTER TABLE public.url_condis OWNER TO jordipsql;
-- ddl-end --

-- object: public.url_bonarea | type: TABLE --
-- DROP TABLE IF EXISTS public.url_bonarea CASCADE;
CREATE TABLE public.url_bonarea (
	id serial NOT NULL,
	fkey_producte integer,
	url text,
	CONSTRAINT id_1 PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON COLUMN public.url_bonarea.url IS E'url on està el producte';
-- ddl-end --
ALTER TABLE public.url_bonarea OWNER TO jordipsql;
-- ddl-end --

-- object: public.crea_quantitat_ambpes | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.crea_quantitat_ambpes(integer,integer,numeric(5,3), integer) CASCADE;
CREATE OR REPLACE FUNCTION public.crea_quantitat_ambpes (IN quant integer, IN fkey integer, IN llast numeric(5,3), OUT identificador integer)
	RETURNS integer
	LANGUAGE plpgsql
	VOLATILE
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
--DECLARE
  --identificador INTEGER;
BEGIN
    INSERT INTO quantitat (quantitat, fkey_historicpreus, pes) SELECT quant,fkey,llast WHERE NOT EXISTS (SELECT * FROM quantitat WHERE quantitat = quant AND fkey_historicpreus = fkey AND pes = llast );
    identificador:=(SELECT id FROM quantitat WHERE quantitat = quant AND fkey_historicpreus = fkey AND pes = llast);
    RETURN identificador;
$$;
-- ddl-end --
ALTER FUNCTION public.crea_quantitat_ambpes(integer,integer,numeric(5,3)) OWNER TO jordipsql;
-- ddl-end --

-- object: public.eliminats | type: TABLE --
-- DROP TABLE IF EXISTS public.eliminats CASCADE;
CREATE TABLE public.eliminats (
	id serial NOT NULL,
	fkey_producte integer,
	fkey_beneficiari integer,
	baixa date,
	alta date,
	CONSTRAINT id_eliminats PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON TABLE public.eliminats IS E'Taula on col·locar les dates dels elements eliminats';
-- ddl-end --
COMMENT ON COLUMN public.eliminats.fkey_producte IS E'Clau forània del producte. Indica quan es va donar de baixa i, si, es dóna d''alta';
-- ddl-end --
COMMENT ON COLUMN public.eliminats.fkey_beneficiari IS E'Clau forània del comerç. Indica a quin comerç es va donar de baixa';
-- ddl-end --
COMMENT ON COLUMN public.eliminats.baixa IS E'Data en que el producte es dóna de baixa';
-- ddl-end --
COMMENT ON COLUMN public.eliminats.alta IS E'Data en que el producte es dóna d''alta';
-- ddl-end --
ALTER TABLE public.eliminats OWNER TO jordipsql;
-- ddl-end --

-- object: public.crea_cistell | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.crea_cistell(integer, VARIADIC integer[]) CASCADE;
CREATE OR REPLACE FUNCTION public.crea_cistell(OUT resultat integer, VARIADIC variable integer[])
	RETURNS integer
	LANGUAGE plpgsql
	VOLATILE
	CALLED ON NULL INPUT
	COST 1
AS $$
DECLARE
  longitud INTEGER;
BEGIN
  longitud:=(SELECT array_length(variable,1));
  IF longitud = 1 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1) SELECT variable[1] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 IS NULL AND fkey_quantitat_3 IS NULL AND fkey_quantitat_4 IS NULL AND fkey_quantitat_5 IS NULL AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 IS NULL AND fkey_quantitat_3 IS NULL AND fkey_quantitat_4 IS NULL AND fkey_quantitat_5 IS NULL AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 2 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2) SELECT variable[1],variable[2] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 IS NULL AND fkey_quantitat_4 IS NULL AND fkey_quantitat_5 IS NULL AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 IS NULL AND fkey_quantitat_4 IS NULL AND fkey_quantitat_5 IS NULL AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 3 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3) SELECT variable[1],variable[2],variable[3] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 IS NULL AND fkey_quantitat_5 IS NULL AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 IS NULL AND fkey_quantitat_5 IS NULL AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 4 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4) SELECT variable[1],variable[2],variable[3],variable[4] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 IS NULL AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 IS NULL AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 5 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5) SELECT variable[1],variable[2],variable[3],variable[4],variable[5] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 IS NULL AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 6 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 IS NULL AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 7 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 IS NULL AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 8 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 IS NULL AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 9 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 IS NULL AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 10 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 IS NULL AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 11 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 IS NULL AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 12 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 IS NULL AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 13 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 IS NULL AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 14 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13],variable[14] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 IS NULL AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 15 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14,fkey_quantitat_15) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13],variable[14],variable[15] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 IS NULL AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 16 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14,fkey_quantitat_15,fkey_quantitat_16) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13],variable[14],variable[15],variable[16] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 IS NULL AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 17 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14,fkey_quantitat_15,fkey_quantitat_16,fkey_quantitat_17) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13],variable[14],variable[15],variable[16],variable[17] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 IS NULL AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 18 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14,fkey_quantitat_15,fkey_quantitat_16,fkey_quantitat_17,fkey_quantitat_18) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13],variable[14],variable[15],variable[16],variable[17],variable[18] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 IS NULL AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 19 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14,fkey_quantitat_15,fkey_quantitat_16,fkey_quantitat_17,fkey_quantitat_18,fkey_quantitat_19) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13],variable[14],variable[15],variable[16],variable[17],variable[18],variable[19] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 IS NULL AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 20 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14,fkey_quantitat_15,fkey_quantitat_16,fkey_quantitat_17,fkey_quantitat_18,fkey_quantitat_19,fkey_quantitat_20) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13],variable[14],variable[15],variable[16],variable[17],variable[18],variable[19],variable[20] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 = variable[20] AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 = variable[20] AND fkey_quantitat_21 IS NULL AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 21 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14,fkey_quantitat_15,fkey_quantitat_16,fkey_quantitat_17,fkey_quantitat_18,fkey_quantitat_19,fkey_quantitat_20,fkey_quantitat_21) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13],variable[14],variable[15],variable[16],variable[17],variable[18],variable[19],variable[20],variable[21] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 = variable[20] AND fkey_quantitat_21 = variable[21] AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 = variable[20] AND fkey_quantitat_21 = variable[21] AND fkey_quantitat_22 IS NULL AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 22 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14,fkey_quantitat_15,fkey_quantitat_16,fkey_quantitat_17,fkey_quantitat_18,fkey_quantitat_19,fkey_quantitat_20,fkey_quantitat_21,fkey_quantitat_22) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13],variable[14],variable[15],variable[16],variable[17],variable[18],variable[19],variable[20],variable[21],variable[22] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 = variable[20] AND fkey_quantitat_21 = variable[21] AND fkey_quantitat_22 = variable[22] AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 = variable[20] AND fkey_quantitat_21 = variable[21] AND fkey_quantitat_22 = variable[22] AND fkey_quantitat_23 IS NULL AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 23 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14,fkey_quantitat_15,fkey_quantitat_16,fkey_quantitat_17,fkey_quantitat_18,fkey_quantitat_19,fkey_quantitat_20,fkey_quantitat_21,fkey_quantitat_22,fkey_quantitat_23) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13],variable[14],variable[15],variable[16],variable[17],variable[18],variable[19],variable[20],variable[21],variable[22],variable[23] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 = variable[20] AND fkey_quantitat_21 = variable[21] AND fkey_quantitat_22 = variable[22] AND fkey_quantitat_23 = variable[23] AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 = variable[20] AND fkey_quantitat_21 = variable[21] AND fkey_quantitat_22 = variable[22] AND fkey_quantitat_23 = variable[23] AND fkey_quantitat_24 IS NULL AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 24 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14,fkey_quantitat_15,fkey_quantitat_16,fkey_quantitat_17,fkey_quantitat_18,fkey_quantitat_19,fkey_quantitat_20,fkey_quantitat_21,fkey_quantitat_22,fkey_quantitat_23,fkey_quantitat_24) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13],variable[14],variable[15],variable[16],variable[17],variable[18],variable[19],variable[20],variable[21],variable[22],variable[23],variable[24] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 = variable[20] AND fkey_quantitat_21 = variable[21] AND fkey_quantitat_22 = variable[22] AND fkey_quantitat_23 = variable[23] AND fkey_quantitat_24 = variable[24] AND fkey_quantitat_25 IS NULL);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 = variable[20] AND fkey_quantitat_21 = variable[21] AND fkey_quantitat_22 = variable[22] AND fkey_quantitat_23 = variable[23] AND fkey_quantitat_24 = variable[24] AND fkey_quantitat_25 IS NULL);
  ELSIF longitud = 25 THEN
    INSERT INTO cistell_compra (fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14,fkey_quantitat_15,fkey_quantitat_16,fkey_quantitat_17,fkey_quantitat_18,fkey_quantitat_19,fkey_quantitat_20,fkey_quantitat_21,fkey_quantitat_22,fkey_quantitat_23,fkey_quantitat_24,fkey_quantitat_25) SELECT variable[1],variable[2],variable[3],variable[4],variable[5],variable[6],variable[7],variable[8],variable[9],variable[10],variable[11],variable[12],variable[13],variable[14],variable[15],variable[16],variable[17],variable[18],variable[19],variable[20],variable[21],variable[22],variable[23],variable[24],variable[25] WHERE NOT EXISTS (SELECT * FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 = variable[20] AND fkey_quantitat_21 = variable[21] AND fkey_quantitat_22 = variable[22] AND fkey_quantitat_23 = variable[23] AND fkey_quantitat_24 = variable[24] AND fkey_quantitat_25 = variable[25]);
    resultat := (SELECT id FROM cistell_compra WHERE fkey_quantitat_1 = variable[1] AND fkey_quantitat_2 = variable[2] AND fkey_quantitat_3 = variable[3] AND fkey_quantitat_4 = variable[4] AND fkey_quantitat_5 = variable[5] AND fkey_quantitat_6 = variable[6] AND fkey_quantitat_7 = variable[7] AND fkey_quantitat_8 = variable[8] AND fkey_quantitat_9 = variable[9] AND fkey_quantitat_10 = variable[10] AND fkey_quantitat_11 = variable[11] AND fkey_quantitat_12 = variable[12] AND fkey_quantitat_13 = variable[13] AND fkey_quantitat_14 = variable[14] AND fkey_quantitat_15 = variable[15] AND fkey_quantitat_16 = variable[16] AND fkey_quantitat_17 = variable[17] AND fkey_quantitat_18 = variable[18] AND fkey_quantitat_19 = variable[19] AND fkey_quantitat_20 = variable[20] AND fkey_quantitat_21 = variable[21] AND fkey_quantitat_22 = variable[22] AND fkey_quantitat_23 = variable[23] AND fkey_quantitat_24 = variable[24] AND fkey_quantitat_25 = variable[25]);
  END IF;
END;
$$;
-- ddl-end --
ALTER FUNCTION public.crea_cistell(integer, VARIADIC integer[]) OWNER TO jordipsql;
-- ddl-end --

-- object: public.taulatiquets | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.taulatiquets(integer) CASCADE;
CREATE OR REPLACE FUNCTION public.taulatiquets(variable integer)
  RETURNS TABLE(nom text, descripcio text, ean text, ofertes text, pvp numeric, quantitat integer)
  LANGUAGE plpgsql
  STRICT COST 1
AS $function$
DECLARE
    longitud INTEGER;
    hola INTEGER;
    sortida1 RECORD;
    posicio refcursor;
    tiquets INTEGER;
  BEGIN
    EXECUTE 'SELECT count(col) not_null_col_cnt FROM (SELECT id,unnest(ARRAY [fkey_quantitat_1,fkey_quantitat_2,fkey_quantitat_3,fkey_quantitat_4,fkey_quantitat_5,fkey_quantitat_6,fkey_quantitat_7,fkey_quantitat_8,fkey_quantitat_9,fkey_quantitat_10,fkey_quantitat_11,fkey_quantitat_12,fkey_quantitat_13,fkey_quantitat_14,fkey_quantitat_15,fkey_quantitat_16,fkey_quantitat_17,fkey_quantitat_18,fkey_quantitat_19,fkey_quantitat_20,fkey_quantitat_21,fkey_quantitat_22,fkey_quantitat_23,fkey_quantitat_24,fkey_quantitat_25]) col FROM cistell_compra) t WHERE id = ' || variable || ' GROUP BY id ORDER BY id' INTO longitud;
    FOR counter IN 1..longitud
    LOOP
      EXECUTE 'SELECT fkey_quantitat_' || counter || ' from cistell_compra where id = ' || variable INTO hola;
      RETURN QUERY EXECUTE 'SELECT pr.nom,pr.descripcio,pr.ean,hi.ofertes,hi.pvp,qu.quantitat FROM quantitat AS qu INNER JOIN historicpreus AS hi ON hi.id = qu.fkey_historicpreus INNER JOIN producte AS pr ON pr.id = hi.fkey_producte WHERE qu.id = ' || hola;
    END LOOP;
  END;
$function$;
-- ddl-end --
ALTER FUNCTION public.taulatiquets(integer) OWNER TO jordipsql;
-- ddl-end --

-- object: public.trigger_funcio_stock_historicpreus | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.trigger_funcio_stock_historicpreus() CASCADE;
CREATE FUNCTION public.trigger_funcio_stock_historicpreus ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	PARALLEL UNSAFE
	COST 1
	AS $$
BEGIN
    -- No existeix el producte
    IF (SELECT EXISTS(SELECT id FROM eliminats WHERE fkey_producte = OLD.fkey_producte AND fkey_beneficiari = OLD.fkey_beneficiari AND baixa IS NULL AND alta IS NULL)) IS FALSE THEN
        IF OLD.stock IS TRUE AND NEW.stock IS FALSE THEN
            INSERT INTO eliminats (fkey_producte,fkey_beneficiari,baixa) SELECT OLD.fkey_producte,OLD.fkey_beneficiari,(SELECT current_date) WHERE NOT EXISTS (SELECT * FROM eliminats WHERE fkey_producte = OLD.fkey_producte AND fkey_beneficiari = OLD.fkey_beneficiari AND baixa = (SELECT current_date));
        -- Evitem crear entrada quan s'insereixi un nou producte
        --ELSIF OLD.stock IS FALSE AND NEW.stock IS TRUE THEN
            --UPDATE eliminats SET alta = (SELECT current_date) WHERE id = (SELECT id FROM eliminats WHERE fkey_producte = OLD.fkey_producte AND fkey_beneficiari = OLD.fkey_beneficiari AND baixa IS NOT NULL AND alta IS NULL);
        END IF;
    -- Existeix el producte amb NOMÉS BAIXA
    ELSIF (SELECT EXISTS(SELECT id FROM eliminats WHERE fkey_producte = OLD.fkey_producte AND fkey_beneficiari = OLD.fkey_beneficiari AND baixa IS NOT NULL AND alta IS NULL)) IS TRUE THEN
        -- Aquest cas es fa a l_anterior
        --IF OLD.stock IS TRUE AND NEW.stock IS FALSE THEN
            --INSERT INTO eliminats (fkey_producte,fkey_beneficiari,baixa) SELECT OLD.fkey_producte,fkey_beneficiari,(SELECT current_date) WHERE NOT EXISTS (SELECT * FROM eliminats WHERE fkey_producte = OLD.fkey_producte AND fkey_beneficiari = OLD.fkey_beneficiari AND baixa = (SELECT current_date));
        IF OLD.stock IS FALSE AND NEW.stock IS TRUE THEN
            UPDATE eliminats SET alta = (SELECT current_date) WHERE id = (SELECT id FROM eliminats WHERE fkey_producte = OLD.fkey_producte AND fkey_beneficiari = OLD.fkey_beneficiari AND baixa IS NOT NULL AND alta IS NULL);
        END IF;
    -- Existeix el producte amb BAIXA I ALTA
    ELSIF (SELECT EXISTS(SELECT id FROM eliminats WHERE fkey_producte = OLD.fkey_producte AND fkey_beneficiari = OLD.fkey_beneficiari AND baixa IS NOT NULL AND alta IS NOT NULL)) IS TRUE THEN
        INSERT INTO eliminats (fkey_producte,fkey_beneficiari,baixa) VALUES (OLD.fkey_producte,OLD.fkey_beneficiari,(SELECT current_date));
    END IF;
    
    RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION public.trigger_funcio_stock_historicpreus() OWNER TO jordipsql;
-- ddl-end --

-- object: trigger_historicpreus_stock | type: TRIGGER --
-- DROP TRIGGER IF EXISTS trigger_historicpreus_stock ON public.historicpreus CASCADE;
CREATE TRIGGER trigger_historicpreus_stock
	BEFORE UPDATE OF stock
	ON public.historicpreus
	FOR EACH ROW
	EXECUTE PROCEDURE public.trigger_funcio_stock_historicpreus();
-- ddl-end --

-- object: fkey_compte | type: CONSTRAINT --
-- ALTER TABLE public.beneficiari DROP CONSTRAINT IF EXISTS fkey_compte CASCADE;
ALTER TABLE public.beneficiari ADD CONSTRAINT fkey_compte FOREIGN KEY (intern)
REFERENCES public.comptes (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
COMMENT ON CONSTRAINT fkey_compte ON public.beneficiari  IS E'Clau forània per identificar quan es faci una transacció entre un compte meu a un altre compte meu';
-- ddl-end --


-- object: fkey_subcategoria | type: CONSTRAINT --
-- ALTER TABLE public.categoria DROP CONSTRAINT IF EXISTS fkey_subcategoria CASCADE;
ALTER TABLE public.categoria ADD CONSTRAINT fkey_subcategoria FOREIGN KEY (subcategoria)
REFERENCES public.subcategoria (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: fkey_compte | type: CONSTRAINT --
-- ALTER TABLE public.operacions DROP CONSTRAINT IF EXISTS fkey_compte CASCADE;
ALTER TABLE public.operacions ADD CONSTRAINT fkey_compte FOREIGN KEY (fkey_compte)
REFERENCES public.comptes (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --
COMMENT ON CONSTRAINT fkey_compte ON public.operacions  IS E'Clau forània des d_on s_ha pagat';
-- ddl-end --


-- object: fkey_beneficiari | type: CONSTRAINT --
-- ALTER TABLE public.operacions DROP CONSTRAINT IF EXISTS fkey_beneficiari CASCADE;
ALTER TABLE public.operacions ADD CONSTRAINT fkey_beneficiari FOREIGN KEY (fkey_beneficiari)
REFERENCES public.beneficiari (id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --
COMMENT ON CONSTRAINT fkey_beneficiari ON public.operacions  IS E'Clau forania a on s_ha pagat';
-- ddl-end --


-- object: fkey_categoria | type: CONSTRAINT --
-- ALTER TABLE public.operacions DROP CONSTRAINT IF EXISTS fkey_categoria CASCADE;
ALTER TABLE public.operacions ADD CONSTRAINT fkey_categoria FOREIGN KEY (fkey_categoria)
REFERENCES public.categoria (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
COMMENT ON CONSTRAINT fkey_categoria ON public.operacions  IS E'Clau forania del que s_ha comprat, menjar, cotxe, pis, aigua';
-- ddl-end --


-- object: fkey_cistell | type: CONSTRAINT --
-- ALTER TABLE public.operacions DROP CONSTRAINT IF EXISTS fkey_cistell CASCADE;
ALTER TABLE public.operacions ADD CONSTRAINT fkey_cistell FOREIGN KEY (fkey_cistell)
REFERENCES public.cistell_compra (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_1 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_1 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_1 FOREIGN KEY (fkey_quantitat_1)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_2 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_2 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_2 FOREIGN KEY (fkey_quantitat_2)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_3 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_3 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_3 FOREIGN KEY (fkey_quantitat_3)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_4 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_4 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_4 FOREIGN KEY (fkey_quantitat_4)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_5 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_5 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_5 FOREIGN KEY (fkey_quantitat_5)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_6 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_6 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_6 FOREIGN KEY (fkey_quantitat_6)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_7 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_7 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_7 FOREIGN KEY (fkey_quantitat_7)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_8 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_8 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_8 FOREIGN KEY (fkey_quantitat_8)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_9 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_9 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_9 FOREIGN KEY (fkey_quantitat_9)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_10 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_10 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_10 FOREIGN KEY (fkey_quantitat_10)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_11 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_11 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_11 FOREIGN KEY (fkey_quantitat_11)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_12 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_12 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_12 FOREIGN KEY (fkey_quantitat_12)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_13 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_13 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_13 FOREIGN KEY (fkey_quantitat_13)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_14 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_14 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_14 FOREIGN KEY (fkey_quantitat_14)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_15 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_15 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_15 FOREIGN KEY (fkey_quantitat_15)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_16 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_16 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_16 FOREIGN KEY (fkey_quantitat_16)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_17 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_17 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_17 FOREIGN KEY (fkey_quantitat_17)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_18 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_18 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_18 FOREIGN KEY (fkey_quantitat_18)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_19 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_19 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_19 FOREIGN KEY (fkey_quantitat_19)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_20 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_20 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_20 FOREIGN KEY (fkey_quantitat_20)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_21 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_21 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_21 FOREIGN KEY (fkey_quantitat_21)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_22 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_22 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_22 FOREIGN KEY (fkey_quantitat_22)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_23 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_23 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_23 FOREIGN KEY (fkey_quantitat_23)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_24 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_24 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_24 FOREIGN KEY (fkey_quantitat_24)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_quantitat_25 | type: CONSTRAINT --
-- ALTER TABLE public.cistell_compra DROP CONSTRAINT IF EXISTS fkey_quantitat_25 CASCADE;
ALTER TABLE public.cistell_compra ADD CONSTRAINT fkey_quantitat_25 FOREIGN KEY (fkey_quantitat_25)
REFERENCES public.quantitat (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_historicpreus | type: CONSTRAINT --
-- ALTER TABLE public.quantitat DROP CONSTRAINT IF EXISTS fkey_historicpreus CASCADE;
ALTER TABLE public.quantitat ADD CONSTRAINT fkey_historicpreus FOREIGN KEY (fkey_historicpreus)
REFERENCES public.historicpreus (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_producte | type: CONSTRAINT --
-- ALTER TABLE public.historicpreus DROP CONSTRAINT IF EXISTS fkey_producte CASCADE;
ALTER TABLE public.historicpreus ADD CONSTRAINT fkey_producte FOREIGN KEY (fkey_producte)
REFERENCES public.producte (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
COMMENT ON CONSTRAINT fkey_producte ON public.historicpreus  IS E'Clau forània al producte';
-- ddl-end --

-- object: fkey_beneficiari | type: CONSTRAINT --
-- ALTER TABLE public.historicpreus DROP CONSTRAINT IF EXISTS fkey_beneficiari CASCADE;
ALTER TABLE public.historicpreus ADD CONSTRAINT fkey_beneficiari FOREIGN KEY (fkey_beneficiari)
REFERENCES public.beneficiari (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
COMMENT ON CONSTRAINT fkey_beneficiari ON public.historicpreus  IS E'Clau forania comerç';
-- ddl-end --

-- object: fkey_producte | type: CONSTRAINT --
-- ALTER TABLE public.url_sorli DROP CONSTRAINT IF EXISTS fkey_producte CASCADE;
ALTER TABLE public.url_sorli ADD CONSTRAINT fkey_producte FOREIGN KEY (fkey_producte)
REFERENCES public.producte (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_producte | type: CONSTRAINT --
-- ALTER TABLE public.url_condis DROP CONSTRAINT IF EXISTS fkey_producte CASCADE;
ALTER TABLE public.url_condis ADD CONSTRAINT fkey_producte FOREIGN KEY (fkey_producte)
REFERENCES public.producte (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_producte | type: CONSTRAINT --
-- ALTER TABLE public.url_bonarea DROP CONSTRAINT IF EXISTS fkey_producte CASCADE;
ALTER TABLE public.url_bonarea ADD CONSTRAINT fkey_producte FOREIGN KEY (fkey_producte)
REFERENCES public.producte (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_producte | type: CONSTRAINT --
-- ALTER TABLE public.eliminats DROP CONSTRAINT IF EXISTS fkey_producte CASCADE;
ALTER TABLE public.eliminats ADD CONSTRAINT fkey_producte FOREIGN KEY (fkey_producte)
REFERENCES public.producte (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fkey_producte | type: CONSTRAINT --
-- ALTER TABLE public.historicpreus DROP CONSTRAINT IF EXISTS stock CASCADE;
ALTER TABLE public.historicpreus ADD COLUMN stock BOOLEAN DEFAULT '1';
-- ddl-end --



--	Categories i subcategories
INSERT INTO subcategoria (nom) SELECT 'General' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'General' );
INSERT INTO subcategoria (nom) SELECT 'Dentista' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Dentista' );
INSERT INTO subcategoria (nom) SELECT 'Traumatòleg' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Traumatòleg' );
INSERT INTO subcategoria (nom) SELECT 'Osteopata' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Osteopata' );
INSERT INTO categoria (nom,subcategoria) SELECT 'Metge',(SELECT id FROM subcategoria WHERE nom = 'General') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Metge' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'General'));
INSERT INTO categoria (nom,subcategoria) SELECT 'Metge',(SELECT id FROM subcategoria WHERE nom = 'Dentista') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Metge' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Dentista'));
INSERT INTO categoria (nom,subcategoria) SELECT 'Metge',(SELECT id FROM subcategoria WHERE nom = 'Traumatòleg') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Metge' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Traumatòleg'));
INSERT INTO categoria (nom,subcategoria) SELECT 'Metge',(SELECT id FROM subcategoria WHERE nom = 'Osteopata') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Metge' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Osteopata'));

INSERT INTO subcategoria (nom) SELECT 'Gasolina' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Gasolina');
INSERT INTO subcategoria (nom) SELECT 'Assegurança' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Assegurança');
INSERT INTO subcategoria (nom) SELECT 'Mecànic' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Mecànic');
INSERT INTO subcategoria (nom) SELECT 'Peatge' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Peatge');
INSERT INTO subcategoria (nom) SELECT 'Racc' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Racc');
INSERT INTO categoria (nom,subcategoria) SELECT 'Cotxe',(SELECT id FROM subcategoria WHERE nom = 'Gasolina') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Cotxe' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Gasolina'));
INSERT INTO categoria (nom,subcategoria) SELECT 'Cotxe',(SELECT id FROM subcategoria WHERE nom = 'Assegurança') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Cotxe' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Assegurança'));
INSERT INTO categoria (nom,subcategoria) SELECT 'Cotxe',(SELECT id FROM subcategoria WHERE nom = 'Mecànic') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Cotxe' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Mecànic'));
INSERT INTO categoria (nom,subcategoria) SELECT 'Cotxe',(SELECT id FROM subcategoria WHERE nom = 'Peatge') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Cotxe' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Peatge'));
INSERT INTO categoria (nom,subcategoria) SELECT 'Cotxe',(SELECT id FROM subcategoria WHERE nom = 'Racc') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Cotxe' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Racc'));

INSERT INTO subcategoria (nom) SELECT 'Roba' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Roba');
INSERT INTO subcategoria (nom) SELECT 'Medicina' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Medicina');
INSERT INTO subcategoria (nom) SELECT 'Menjar' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Menjar');
INSERT INTO subcategoria (nom) SELECT 'Electrònica' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Electrònica');
INSERT INTO categoria (nom,subcategoria) SELECT 'Compres',(SELECT id FROM subcategoria WHERE nom = 'Roba') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Compres' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Roba'));
INSERT INTO categoria (nom,subcategoria) SELECT 'Compres',(SELECT id FROM subcategoria WHERE nom = 'Medicina') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Compres' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Medicina'));
INSERT INTO categoria (nom,subcategoria) SELECT 'Compres',(SELECT id FROM subcategoria WHERE nom = 'Menjar') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Compres' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Menjar'));
INSERT INTO categoria (nom,subcategoria) SELECT 'Compres',(SELECT id FROM subcategoria WHERE nom = 'Electrònica') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Compres' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Electrònica'));

INSERT INTO subcategoria (nom) SELECT 'Públic' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Públic');
INSERT INTO categoria (nom,subcategoria) SELECT 'Transport',(SELECT id FROM subcategoria WHERE nom = 'Públic') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Transport' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Públic'));

INSERT INTO subcategoria (nom) SELECT 'Normal' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Normal');
INSERT INTO subcategoria (nom) SELECT 'Paga extra' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Paga extra');
INSERT INTO categoria (nom,subcategoria) SELECT 'Nòmina',(SELECT id FROM subcategoria WHERE nom = 'Normal') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Nòmina' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Normal'));
INSERT INTO categoria (nom,subcategoria) SELECT 'Nòmina',(SELECT id FROM subcategoria WHERE nom = 'Paga extra') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Nòmina' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Paga extra'));

INSERT INTO categoria (nom) SELECT 'Telèfon' WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Telèfon');

INSERT INTO subcategoria (nom) SELECT 'Diversió' WHERE NOT EXISTS (SELECT * FROM subcategoria WHERE nom = 'Diversió');
INSERT INTO categoria (nom,subcategoria) SELECT 'Cine',(SELECT id FROM subcategoria WHERE nom = 'Diversió') WHERE NOT EXISTS (SELECT * FROM categoria WHERE nom = 'Cine' AND subcategoria = (SELECT id FROM subcategoria WHERE nom = 'Diversió'));

--	Comerços
INSERT INTO beneficiari (comerc) SELECT 'Sorli' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Sorli' );
INSERT INTO beneficiari (comerc) SELECT 'Condis' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Condis' );
INSERT INTO beneficiari (comerc) SELECT 'Farmàcia' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Farmàcia' );
INSERT INTO beneficiari (comerc) SELECT 'Bon Area' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Bon Area' );
INSERT INTO beneficiari (comerc) SELECT 'Frankfurt' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Frankfurt Casa Vallès' );
INSERT INTO beneficiari (comerc) SELECT 'Can Soler' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Can Soler' );
INSERT INTO beneficiari (comerc) SELECT 'Cervesseria' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Cervesseria' );
INSERT INTO beneficiari (comerc) SELECT 'Paquis' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Paquis' );
INSERT INTO beneficiari (comerc) SELECT 'Quiros' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Quiros');
INSERT INTO beneficiari (comerc) SELECT 'Fnac' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Fnac');
INSERT INTO beneficiari (comerc) SELECT 'Amazon' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Amazon');
INSERT INTO beneficiari (comerc) SELECT 'Fotomaton' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Fotomaton');
INSERT INTO beneficiari (comerc) SELECT 'Abertis' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Abertis');
INSERT INTO beneficiari (comerc) SELECT 'Casa Ametller' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Casa Ametller');
INSERT INTO beneficiari (comerc) SELECT 'Cinesa' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Cinesa');
INSERT INTO beneficiari (comerc) SELECT 'Jijonenca' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Jijonenca');
INSERT INTO beneficiari (comerc) SELECT 'Can Fillol' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Can Fillol');
INSERT INTO beneficiari (comerc) SELECT 'Carlos Román' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Carlos Román');
INSERT INTO beneficiari (comerc) SELECT 'Parking' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Parking');
INSERT INTO beneficiari (comerc) SELECT 'Renfe' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Renfe');
INSERT INTO beneficiari (comerc) SELECT 'Bar' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Bar');
INSERT INTO beneficiari (comerc) SELECT 'Yoigo' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Yoigo');
INSERT INTO beneficiari (comerc) SELECT 'La Caixa' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'La Caixa');
INSERT INTO beneficiari (comerc) SELECT 'Gasolinera' WHERE NOT EXISTS (SELECT * FROM beneficiari WHERE comerc = 'Gasolinera');


-- Bancs
INSERT INTO comptes (banc) SELECT 'La caixa' WHERE NOT EXISTS (SELECT * FROM comptes WHERE banc = 'La caixa');
INSERT INTO comptes (banc) SELECT 'Caixa Enginyers' WHERE NOT EXISTS (SELECT * FROM comptes WHERE banc = 'Caixa Enginyers');
INSERT INTO comptes (banc) SELECT 'Liquid' WHERE NOT EXISTS (SELECT * FROM comptes WHERE banc = 'Liquid');
INSERT INTO comptes (banc) SELECT 'Liquid pedra' WHERE NOT EXISTS (SELECT * FROM comptes WHERE banc = 'Liquid pedra');
INSERT INTO comptes (banc) SELECT 'Paypal' WHERE NOT EXISTS (SELECT * FROM comptes WHERE banc = 'Paypal');
INSERT INTO comptes (banc) SELECT 'Revolut' WHERE NOT EXISTS (SELECT * FROM comptes WHERE banc = 'Revolut');


-- Extensions
CREATE EXTENSION btree_gist;
CREATE EXTENSION intarray;
CREATE INDEX ON historicpreus USING gist(data);


