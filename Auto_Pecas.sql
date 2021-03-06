PGDMP     2    5    	            x            Auto Pecas Aprovados    12.3    12.3 ,    8           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            9           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            :           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            ;           1262    16393    Auto Pecas Aprovados    DATABASE     �   CREATE DATABASE "Auto Pecas Aprovados" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
 &   DROP DATABASE "Auto Pecas Aprovados";
                postgres    false            �            1255    16532    update_de_venda()    FUNCTION        CREATE FUNCTION public.update_de_venda() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

IF NEW.cod_venda > 0 THEN
	
	UPDATE estoque
	SET quantidade = (quantidade - NEW.quantidade)
	WHERE cod_produto = New.cod_produto;

END IF;

RETURN NEW;
END;
$$;
 (   DROP FUNCTION public.update_de_venda();
       public          postgres    false            �            1255    16431    verificar_cadastro_cliente()    FUNCTION     �  CREATE FUNCTION public.verificar_cadastro_cliente() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

--Verificando se CPF foi informado.
IF NEW.cpf IS NULL THEN
	RAISE EXCEPTION 'O CPF de % deve ser informado.', NEW.nome;
END IF;

--Verificando se o nome foi informado.
IF NEW.nome IS NULL THEN
	RAISE EXCEPTION 'O campo NOME deve ser preenchido.';
END IF;

--Verificando se o endereço foi informado.
IF NEW.endereço IS NULL THEN
	RAISE EXCEPTION 'O endereço de % deve ser informado.', NEW.nome;
END IF;

--Informando telefone vazio.
IF NEW.telefone IS NULL THEN
	RAISE EXCEPTION 'O telefone de % deve ser informado', NEW.nome;
END IF;

--Automatizando o campo data_de_cadastro.
NEW.data_de_cadastro = CURRENT_DATE;

RETURN NEW;
END;
$$;
 3   DROP FUNCTION public.verificar_cadastro_cliente();
       public          postgres    false            �            1255    16476    verificar_cadastro_fornecedor()    FUNCTION     �  CREATE FUNCTION public.verificar_cadastro_fornecedor() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

--Verificar se cod_fornecedor foi informado.
IF NEW.cod_fornecedor IS NULL THEN
	RAISE EXCEPTION 'O código do fornecedor % deve ser informado.', NEW.nome;
END IF;

--Verificar se CNPJ foi informado.
IF NEW.cnpj IS NULL THEN
	RAISE EXCEPTION 'O CNPJ do fornecedor % deve ser informado.', NEW.nome;
END IF;

--Verificar se nome foi informado.
IF NEW.nome IS NULL THEN
	RAISE EXCEPTION 'O nome do fornecedor deve ser informado.';
END IF;

--Verificar se telefone foi informado.
IF NEW.telefone IS NULL THEN
	RAISE EXCEPTION 'O telefone do fornecedor % deve ser informado.', NEW.nome;
END IF;

RETURN NEW;
END;

$$;
 6   DROP FUNCTION public.verificar_cadastro_fornecedor();
       public          postgres    false            �            1255    16474     verificar_cadastro_funcionario()    FUNCTION     d  CREATE FUNCTION public.verificar_cadastro_funcionario() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

--Verificar se nome foi informado.
IF NEW.nome IS NULL THEN
	RAISE EXCEPTION 'O nome do funcionário deve ser informado.';
END IF;

--Verficar se CPF foi informado.
IF NEW.cpf IS NULL THEN
	RAISE EXCEPTION 'O cpf do funcionário % deve ser informado.', NEW.nome;
END IF;

--Verificar se CPF existe.
IF NEW.cpf = OLD.cpf THEN
	RAISE EXCEPTION 'O CPF ja foi cadastrado.';
END IF;

--Verificar se endereço foi informado.
IF NEW.endereco IS NULL THEN
	RAISE EXCEPTION 'O endereço do funcionário % deve ser informado.', NEW.nome;
END IF;

--Verificar se telefone foi informado.
IF NEW.telefone IS NULL THEN
	RAISE EXCEPTION 'O telefone do funcionário % deve ser informado.', NEW.nome;
END IF;

--Verificar se Cod_funcionario foi informado.
IF NEW.cod_funcionario IS NULL THEN
	RAISE EXCEPTION 'O código do funcionário % deve ser informado.', NEW.nome;
END IF;

--Verificar se cargo foi informado.
IF NEW.cargo IS NULL THEN
	RAISE EXCEPTION 'O cargo do funcionário % deve ser informado.', NEW.nome;
END IF;

--Verificar se salário é justo.
IF NEW.salario < 1039 THEN
	NEW.salario = 1039;
END IF;

--Verificar se salário é nulo.
IF NEW.salario IS NULL THEN
	RAISE EXCEPTION 'O salário do funcionário % não pode ser nulo.', NEW.nome;
END IF;

RETURN NEW;
END;
$$;
 7   DROP FUNCTION public.verificar_cadastro_funcionario();
       public          postgres    false            �            1255    16479    verificar_cadastro_produto()    FUNCTION     �  CREATE FUNCTION public.verificar_cadastro_produto() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

--Verificar se cod_produto foi informado.
IF NEW.cod_produto IS NULL THEN
	RAISE EXCEPTION 'O código do produto % deve ser informado.', NEW.nome;
END IF;

--Verificar se cod_produto não é negativo.
IF NEW.cod_produto < 0 THEN
	RAISE EXCEPTION 'O código do produto % não pode ser negativo.', NEW.nome;
END IF;

--Verificar se o nome foi informado.
IF NEW.nome IS NULL THEN
	RAISE EXCEPTION 'O nome do produto com código % deve ser informado.', NEW.cod_produto;
END IF;

--Verificar se o cod_fornecedor foi informado.
IF NEW.cod_fornecedor IS NULL THEN
	RAISE EXCEPTION 'O código do fornecedor do produto %, código % deve ser informado', NEW.nome, NEW.cod_produto;
END IF;

--Verificar se preço foi informado.
IF NEW.preco IS NULL THEN
	RAISE EXCEPTION 'O preço do produto %, código % deve ser informado.', NEW.nome, NEW.cod_produto;
END IF;

--Verificar se o preço não é negativo.
IF NEW.preco < 0 THEN
	RAISE EXCEPTION 'O preço do produto %, código % não pode ser negativo', NEW.nome, NEW.cod_produto;
END IF;


RETURN NEW;
END;
$$;
 3   DROP FUNCTION public.verificar_cadastro_produto();
       public          postgres    false            �            1255    16534    verificar_estoque()    FUNCTION       CREATE FUNCTION public.verificar_estoque() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

--Verificando se o codigo do fornecedor é nulo.
IF NEW.cod_fornecedor IS NULL THEN
	RAISE EXCEPTION 'O campo "cod_fornecedor" não pode ser nulo.';
END IF;

--verificando se o codigo do fornecedor é negativo.
IF NEW.cod_fornecedor < 0 THEN
	RAISE EXCEPTION 'O campo "cod_fornecedor" não pode ser negativo.';
END IF;

--Verificando se o codigo do produto é nulo.
IF NEW.cod_produto IS NULL THEN
	RAISE EXCEPTION 'O campo "cod_produto" não pode ser nulo.';
END IF;

--verificando se o codigo do produto é negativo.
IF NEW.cod_produto < 0 THEN
	RAISE EXCEPTION 'O campo "cod_produto" não pode ser negativo.';
END IF;

--Verificando se a quantidade é nulo e atribuindo 0, caso verdadeiro.
IF NEW.quantidade IS NULL THEN
	NEW.quantidade = 0;
END IF;

--verificando se a quantidade é negativo.
IF NEW.quantidade < 0 THEN
	RAISE EXCEPTION 'Produto % indiponível no estoque.', new.cod_produto;
END IF;

RETURN NEW;
END;

$$;
 *   DROP FUNCTION public.verificar_estoque();
       public          postgres    false            �            1255    16512    verificar_venda()    FUNCTION     	  CREATE FUNCTION public.verificar_venda() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN 

--Verificando se codigo do funcionario é nulo.
IF NEW.cod_funcionario IS NULL THEN
	RAISE EXCEPTION 'O campo "cod_funcionario" não pode ser nulo.';
END IF;

--Verficando se codigo do funcionario é menor que zero.
IF NEW.cod_funcionario < 0 THEN
	RAISE EXCEPTION 'O campo "cod_funcionario" não pode ser negativo.';
END IF;

--Verificando se codigo do produto é nulo.
IF NEW.cod_produto IS NULL THEN
	RAISE EXCEPTION 'O campo "cod_produto" não pode ser nulo.';
END IF;

--Verficando se codigo do produto é menor que zero.
IF NEW.cod_produto < 0 THEN
	RAISE EXCEPTION 'O campo "cod_produto" não pode ser negativo.';
END IF;

--Verificando se quantidade é nulo e atribuindo 0, caso verdadeiro.
IF NEW.quantidade IS NULL THEN
	NEW.quantidade = 0;
END IF;

--Verficando se codigo do produto é menor que zero.
IF NEW.quantidade < 0 THEN
	RAISE EXCEPTION 'O campo "quantidade" não pode ser negativo.';
END IF;

RETURN NEW;
END; 
$$;
 (   DROP FUNCTION public.verificar_venda();
       public          postgres    false            �            1259    16466    cliente    TABLE     �   CREATE TABLE public.cliente (
    cpf character varying(11) NOT NULL,
    nome character varying(50),
    "endereço" character varying(80),
    telefone character varying(11),
    data_de_cadastro date
);
    DROP TABLE public.cliente;
       public         heap    postgres    false            �            1259    16499    estoque    TABLE     m   CREATE TABLE public.estoque (
    cod_fornecedor integer,
    cod_produto integer,
    quantidade integer
);
    DROP TABLE public.estoque;
       public         heap    postgres    false            �            1259    16404 
   fornecedor    TABLE     �   CREATE TABLE public.fornecedor (
    cod_fornecedor integer NOT NULL,
    cnpj character varying(18),
    nome character varying(50),
    telefone character varying(11)
);
    DROP TABLE public.fornecedor;
       public         heap    postgres    false            �            1259    16399    funcionario    TABLE       CREATE TABLE public.funcionario (
    cpf character varying(11),
    nome character varying(50),
    endereco character varying(80),
    telefone character varying(25),
    cargo character varying(50),
    salario real,
    cod_funcionario integer NOT NULL
);
    DROP TABLE public.funcionario;
       public         heap    postgres    false            �            1259    24585    funcionario_cod_funcionario_seq    SEQUENCE     �   CREATE SEQUENCE public.funcionario_cod_funcionario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.funcionario_cod_funcionario_seq;
       public          postgres    false    202            <           0    0    funcionario_cod_funcionario_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.funcionario_cod_funcionario_seq OWNED BY public.funcionario.cod_funcionario;
          public          postgres    false    207            �            1259    16409    produto    TABLE     �   CREATE TABLE public.produto (
    cod_produto integer NOT NULL,
    nome character varying(50),
    cod_fornecedor integer,
    preco real
);
    DROP TABLE public.produto;
       public         heap    postgres    false            �            1259    24596    venda    TABLE     �   CREATE TABLE public.venda (
    cod_funcionario integer,
    cod_produto integer,
    quantidade integer,
    cod_venda integer NOT NULL
);
    DROP TABLE public.venda;
       public         heap    postgres    false            �
           2604    24587    funcionario cod_funcionario    DEFAULT     �   ALTER TABLE ONLY public.funcionario ALTER COLUMN cod_funcionario SET DEFAULT nextval('public.funcionario_cod_funcionario_seq'::regclass);
 J   ALTER TABLE public.funcionario ALTER COLUMN cod_funcionario DROP DEFAULT;
       public          postgres    false    207    202            2          0    16466    cliente 
   TABLE DATA           U   COPY public.cliente (cpf, nome, "endereço", telefone, data_de_cadastro) FROM stdin;
    public          postgres    false    205   `K       3          0    16499    estoque 
   TABLE DATA           J   COPY public.estoque (cod_fornecedor, cod_produto, quantidade) FROM stdin;
    public          postgres    false    206   [L       0          0    16404 
   fornecedor 
   TABLE DATA           J   COPY public.fornecedor (cod_fornecedor, cnpj, nome, telefone) FROM stdin;
    public          postgres    false    203   �L       /          0    16399    funcionario 
   TABLE DATA           e   COPY public.funcionario (cpf, nome, endereco, telefone, cargo, salario, cod_funcionario) FROM stdin;
    public          postgres    false    202   �L       1          0    16409    produto 
   TABLE DATA           K   COPY public.produto (cod_produto, nome, cod_fornecedor, preco) FROM stdin;
    public          postgres    false    204   2M       5          0    24596    venda 
   TABLE DATA           T   COPY public.venda (cod_funcionario, cod_produto, quantidade, cod_venda) FROM stdin;
    public          postgres    false    208   pM       =           0    0    funcionario_cod_funcionario_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.funcionario_cod_funcionario_seq', 7, true);
          public          postgres    false    207            �
           2606    16470    cliente cliente_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cpf);
 >   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
       public            postgres    false    205            �
           2606    16413    produto estoque_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.produto
    ADD CONSTRAINT estoque_pkey PRIMARY KEY (cod_produto);
 >   ALTER TABLE ONLY public.produto DROP CONSTRAINT estoque_pkey;
       public            postgres    false    204            �
           2606    16408    fornecedor fornecedor_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.fornecedor
    ADD CONSTRAINT fornecedor_pkey PRIMARY KEY (cod_fornecedor);
 D   ALTER TABLE ONLY public.fornecedor DROP CONSTRAINT fornecedor_pkey;
       public            postgres    false    203            �
           2606    24589    funcionario funcionario_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cod_funcionario);
 F   ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
       public            postgres    false    202            �
           2606    24629    venda venda_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_pkey PRIMARY KEY (cod_venda);
 :   ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_pkey;
       public            postgres    false    208            �
           2620    24612    venda update_de_venda    TRIGGER        CREATE TRIGGER update_de_venda BEFORE INSERT OR UPDATE ON public.venda FOR EACH ROW EXECUTE FUNCTION public.update_de_venda();
 .   DROP TRIGGER update_de_venda ON public.venda;
       public          postgres    false    208    223            �
           2620    16471 "   cliente verificar_cadastro_cliente    TRIGGER     �   CREATE TRIGGER verificar_cadastro_cliente BEFORE INSERT OR UPDATE ON public.cliente FOR EACH ROW EXECUTE FUNCTION public.verificar_cadastro_cliente();
 ;   DROP TRIGGER verificar_cadastro_cliente ON public.cliente;
       public          postgres    false    221    205            �
           2620    16477 (   fornecedor verificar_cadastro_fornecedor    TRIGGER     �   CREATE TRIGGER verificar_cadastro_fornecedor BEFORE INSERT OR UPDATE ON public.fornecedor FOR EACH ROW EXECUTE FUNCTION public.verificar_cadastro_fornecedor();
 A   DROP TRIGGER verificar_cadastro_fornecedor ON public.fornecedor;
       public          postgres    false    203    222            �
           2620    16475 *   funcionario verificar_cadastro_funcionario    TRIGGER     �   CREATE TRIGGER verificar_cadastro_funcionario BEFORE INSERT OR UPDATE ON public.funcionario FOR EACH ROW EXECUTE FUNCTION public.verificar_cadastro_funcionario();
 C   DROP TRIGGER verificar_cadastro_funcionario ON public.funcionario;
       public          postgres    false    202    224            �
           2620    16480 "   produto verificar_cadastro_produto    TRIGGER     �   CREATE TRIGGER verificar_cadastro_produto BEFORE INSERT OR UPDATE ON public.produto FOR EACH ROW EXECUTE FUNCTION public.verificar_cadastro_produto();
 ;   DROP TRIGGER verificar_cadastro_produto ON public.produto;
       public          postgres    false    204    225            �
           2620    16538    estoque verificar_estoque    TRIGGER     �   CREATE TRIGGER verificar_estoque BEFORE INSERT OR UPDATE ON public.estoque FOR EACH ROW EXECUTE FUNCTION public.verificar_estoque();
 2   DROP TRIGGER verificar_estoque ON public.estoque;
       public          postgres    false    206    227            �
           2620    24613    venda verificar_venda    TRIGGER        CREATE TRIGGER verificar_venda BEFORE INSERT OR UPDATE ON public.venda FOR EACH ROW EXECUTE FUNCTION public.verificar_venda();
 .   DROP TRIGGER verificar_venda ON public.venda;
       public          postgres    false    226    208            �
           2606    16414    produto cod_fornecedor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.produto
    ADD CONSTRAINT cod_fornecedor_fkey FOREIGN KEY (cod_fornecedor) REFERENCES public.fornecedor(cod_fornecedor);
 E   ALTER TABLE ONLY public.produto DROP CONSTRAINT cod_fornecedor_fkey;
       public          postgres    false    2718    204    203            �
           2606    16502    estoque cod_fornecedor_pkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estoque
    ADD CONSTRAINT cod_fornecedor_pkey FOREIGN KEY (cod_fornecedor) REFERENCES public.fornecedor(cod_fornecedor);
 E   ALTER TABLE ONLY public.estoque DROP CONSTRAINT cod_fornecedor_pkey;
       public          postgres    false    2718    206    203            �
           2606    24602    venda cod_funcionario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.venda
    ADD CONSTRAINT cod_funcionario_fkey FOREIGN KEY (cod_funcionario) REFERENCES public.funcionario(cod_funcionario);
 D   ALTER TABLE ONLY public.venda DROP CONSTRAINT cod_funcionario_fkey;
       public          postgres    false    2716    208    202            �
           2606    24607    venda cod_produto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.venda
    ADD CONSTRAINT cod_produto_fkey FOREIGN KEY (cod_produto) REFERENCES public.produto(cod_produto);
 @   ALTER TABLE ONLY public.venda DROP CONSTRAINT cod_produto_fkey;
       public          postgres    false    204    208    2720            �
           2606    16507    estoque cod_produto_pkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estoque
    ADD CONSTRAINT cod_produto_pkey FOREIGN KEY (cod_produto) REFERENCES public.produto(cod_produto);
 B   ALTER TABLE ONLY public.estoque DROP CONSTRAINT cod_produto_pkey;
       public          postgres    false    204    2720    206            2   �   x�e��J�@���)�*����c
"�(�
^�,�`Wb���oӣ��s�VHq�3?��jx��U5^�x��ɩ
���,��j��+4+m$�� �u��q���_j�5B3��Y5`�87��JB�����������1d�d,�U
,����3���?]{<@��&ʖ�(2�y��+���[�-�-�f�0�>�Yé� y�e)��޻WQ�<tA�Q[�?.���&I�_�\<      3      x�373�444��4�02�����  �      0   %   x�373�4422����KI�41001600����� [��      /   g   x�=�;
�0 �99EO �Z?��(���K�Al���+���0p<71��[`Nl�CvM`me�h`���k��l5z��p����-�(K�`��G��O5�">�,      1   .   x�344��t�O��KTH�WJL�LL�/�473�4��4����� �H	�      5   0   x�3�444��4�4�2�1�`LCNc��	�i�`���F��\1z\\\ Q�     