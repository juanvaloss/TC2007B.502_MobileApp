PGDMP  ;    9             	    |         	   mobileapp    16.4    16.4     	           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            
           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16395 	   mobileapp    DATABASE     k   CREATE DATABASE mobileapp WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';
    DROP DATABASE mobileapp;
                adminapp    false            �            1259    16397    users    TABLE     �   CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(30),
    mail character varying(256),
    password character varying(256),
    pin integer
);
    DROP TABLE public.users;
       public         heap    adminapp    false            �            1259    16396    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          adminapp    false    216                       0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          adminapp    false    215            s           2604    16400    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          adminapp    false    216    215    216                      0    16397    users 
   TABLE DATA           >   COPY public.users (id, name, mail, password, pin) FROM stdin;
    public          adminapp    false    216   e
                  0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 1, true);
          public          adminapp    false    215            u           2606    16404    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            adminapp    false    216               <   x�3��*M�Sp,K��/�����������D��������\�\jI*����W� ���     