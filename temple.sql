--
-- PostgreSQL database dump
--

\restrict 7mtMZD9IHrfJXee1agm89hz5Ra2KzFsbGsN72MoqYFOhvcGgoBMRyDs8m3BKf89

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    instance_id uuid NOT NULL,
    member_id uuid,
    visitor_name character varying(200),
    checked_in_at timestamp with time zone DEFAULT now(),
    status character varying(20) DEFAULT 'Present'::character varying,
    CONSTRAINT attendance_status_check CHECK (((status)::text = ANY (ARRAY[('Present'::character varying)::text, ('Excused'::character varying)::text, ('Absent'::character varying)::text])))
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: event_instances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_instances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_id uuid NOT NULL,
    date date NOT NULL,
    status character varying(20) DEFAULT 'scheduled'::character varying,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    name_override character varying(200),
    type_override character varying(50),
    location_override character varying(255),
    CONSTRAINT event_instances_status_check CHECK (((status)::text = ANY (ARRAY[('scheduled'::character varying)::text, ('completed'::character varying)::text, ('cancelled'::character varying)::text])))
);


ALTER TABLE public.event_instances OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(200) NOT NULL,
    type character varying(50) DEFAULT 'Service'::character varying,
    location character varying(255),
    start_time time without time zone,
    is_recurring boolean DEFAULT false,
    recurrence_rule character varying(20),
    day_of_week smallint,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    zone_id uuid,
    CONSTRAINT events_day_of_week_check CHECK ((((day_of_week >= 0) AND (day_of_week <= 6)) OR (day_of_week IS NULL))),
    CONSTRAINT events_recurrence_rule_check CHECK ((((recurrence_rule)::text = ANY (ARRAY[('weekly'::character varying)::text, ('biweekly'::character varying)::text, ('monthly'::character varying)::text, ('yearly'::character varying)::text])) OR (recurrence_rule IS NULL))),
    CONSTRAINT events_type_check CHECK (((type)::text = ANY (ARRAY[('Service'::character varying)::text, ('Meeting'::character varying)::text, ('Special'::character varying)::text, ('Workshop'::character varying)::text, ('Prayer'::character varying)::text, ('Youth'::character varying)::text])))
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255),
    phone character varying(20),
    address text,
    status character varying(20) DEFAULT 'Active'::character varying,
    zone_id uuid,
    join_date date DEFAULT CURRENT_DATE,
    avatar_url text,
    notes text,
    dob date,
    gender character varying(10),
    role character varying(50),
    occupation character varying(100),
    emergency_contact character varying(100),
    emergency_phone character varying(20),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    discovery_source character varying(50),
    marital_status character varying(20),
    marriage_date date,
    mother_name character varying(100),
    mother_status character varying(20),
    father_name character varying(100),
    father_status character varying(20),
    spouse_name character varying(100),
    spouse_phone character varying(20),
    is_baptized boolean DEFAULT false,
    baptism_date date,
    baptized_by character varying(100),
    baptism_method character varying(50),
    baptism_church character varying(150),
    children jsonb DEFAULT '[]'::jsonb,
    other_name character varying(150),
    titles jsonb DEFAULT '[]'::jsonb NOT NULL,
    ex_member_reason text,
    member_id character varying(20) NOT NULL,
    CONSTRAINT members_gender_check CHECK ((((gender)::text = ANY (ARRAY[('Male'::character varying)::text, ('Female'::character varying)::text, ('Other'::character varying)::text])) OR (gender IS NULL))),
    CONSTRAINT members_status_check CHECK (((status)::text = ANY (ARRAY[('Active'::character varying)::text, ('Inactive'::character varying)::text, ('Visitor'::character varying)::text, ('Ex-member'::character varying)::text])))
);


ALTER TABLE public.members OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    content text NOT NULL,
    channel character varying(10) DEFAULT 'sms'::character varying NOT NULL,
    recipient_type character varying(20) NOT NULL,
    recipient_target character varying(255),
    recipient_label character varying(255),
    recipient_count integer DEFAULT 0 NOT NULL,
    status character varying(20) DEFAULT 'sent'::character varying NOT NULL,
    type character varying(20) DEFAULT 'manual'::character varying NOT NULL,
    sent_at timestamp with time zone DEFAULT now(),
    sender_user_id uuid,
    sender_role character varying(20),
    sender_zone_id uuid
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    applied_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL,
    is_system boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    value text NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.settings_id_seq OWNER TO postgres;

--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(120),
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    role character varying(20) NOT NULL,
    member_id uuid,
    zone_id uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    role_id uuid,
    mfa_enabled boolean DEFAULT false,
    mfa_code character varying(10),
    mfa_code_expires_at timestamp with time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: zones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zones (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    leader character varying(100),
    description text,
    meeting_time character varying(50),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    leader_id uuid
);


ALTER TABLE public.zones OWNER TO postgres;

--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (id, instance_id, member_id, visitor_name, checked_in_at, status) FROM stdin;
\.


--
-- Data for Name: event_instances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_instances (id, event_id, date, status, notes, created_at, name_override, type_override, location_override) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, name, type, location, start_time, is_recurring, recurrence_rule, day_of_week, is_active, created_at, updated_at, zone_id) FROM stdin;
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.members (id, first_name, last_name, email, phone, address, status, zone_id, join_date, avatar_url, notes, dob, gender, role, occupation, emergency_contact, emergency_phone, created_at, updated_at, discovery_source, marital_status, marriage_date, mother_name, mother_status, father_name, father_status, spouse_name, spouse_phone, is_baptized, baptism_date, baptized_by, baptism_method, baptism_church, children, other_name, titles, ex_member_reason, member_id) FROM stdin;
a719f08e-0135-4766-9fe1-fea850db2d2d	Samuel	Baah Frimpong	kobbyniche@gmail.com	0506988252	7 Chickweed Street	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 11.43.47.jpeg	\N	2000-08-22	Male	\N	Student	Augustina Baah	0245049233	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-SAMU-5775
674470a7-de3d-4a19-af71-087a119d35c5	Serlom	Solomon Nyamalor	selormsolomon15@gmail.com	0502383425	Madina	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 12.43.39_f3ef3c40.jpg	\N	1998-07-15	Male	\N	Music Executive	Vivian Addo-Sunu	0277485244	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-SERL-4876
5065be19-825b-4e4d-8702-a94c472c5998	Elizabeth	Agyemang	\N	0241382585	lakeside	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 11.39.44.jpeg	\N	1994-12-06	Female	\N	Trader	Isaac Agyemang	0549743504	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ELIZ-7156
f12b3b46-682e-4760-935a-6d3a60161dad	Juliana	Yeaboah Annor	julianaannor@yahoo.com	0241238882	Madina	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/Lady Julia.jpeg	\N	1997-02-07	Female	\N	Bussiness Woman	Esther Asare	0266485584	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-JULI-6054
065997cb-50d7-4c12-9907-bfbbd7bcc34d	Esther	Asare	\N	0266485584	Madina	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	/uploads/avatars/Esther Asare.jpeg	\N	1966-07-10	Female	\N	Self employed	Juliana	0241238882	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Widowed	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ESTH-5589
71555045-9368-49b7-b4f7-372c90b4ffb1	Gifty	Kumako	\N	0245894567	Baba Yara	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	/uploads/avatars/Gifty Kumasi.jpeg	\N	1977-08-05	Female	\N	Trader	Emmanuel Kofi Dagor	0542795251	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GIFT-8174
3e0a8e0b-9c55-4e38-b922-5dc335a367ae	Janet	Dortsu	\N	0544260183	Madina UN	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	/uploads/avatars/Janet Dortsu.jpeg	\N	1958-04-28	Female	\N	Unemployed	Doris Konadu	0207337025	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Widowed	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-JANE-4982
7667842e-8fc2-46d3-9d48-eb71bf435e1c	Gifty	Larbi	\N	0244821036	Dome Abra Old NDC	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	/uploads/avatars/Gifty Larbi.jpeg	\N	1972-07-12	Female	\N	Hairdresser	Ataa	0245513236	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GIFT-3844
cd7c4edf-5d8f-4716-8398-f69ac64dda70	Doris	Konadu Opoku	\N	0207337025	Madina UN	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	/uploads/avatars/1 Doris.jpeg	\N	1980-03-07	Female	\N	Hairdresser	Jessica	0256869513	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DORI-1210
e0021645-bacd-4ffc-9b4d-410393cd1095	Regina	Adobea	\N	0551150136	Atima	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	\N	\N	1961-08-12	Female	\N	Trader	Silvia Adobea	5555	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Widowed	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-REGI-6211
8f235ee7-6d16-49cb-b89f-e6cc73ce0663	Jessica	Mansah Asamoah	jmansah206@gmail.com	0256869513	Madina UN	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	\N	\N	1999-02-28	Female	\N	fashion	Doris Konadu	0207337025	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-JESS-2366
dcccc013-690e-4ddb-8dcb-a09dab0694b8	Daniel	Ansah	\N	0249745462	Madina Deeper life	Active	9613f4af-4031-4043-85ff-8e0c85eae299	\N	\N	\N	1985-06-01	Male	\N	Media and events (Adom Fm	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DANI-0653
f822d663-d6a3-4ea7-a094-44daadb06c2b	Georgina	Achampong	\N	0534881112	Madina	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	\N	\N	1976-10-10	Female	\N	Business woman	Winniefred	0553847121	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GEOR-0667
d025f13c-ab8e-4295-9494-f3018a8671ab	Kwadwo	Adjie-Darko	\N	0537600083	Alpha Lodge	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	\N	\N	2009-03-30	Male	\N	Student	Wilberforce Kwesi-Darko	0244385268	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-KWAD-4849
c5daf764-b0cf-4d62-b555-b877968f57ec	Juliana	Agyeman	\N	0542882521	Madina Domeabra	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	\N	\N	1964-06-05	Female	\N	Businesswoman	Ivy Agyeman	0592326178	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Widowed	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-JULI-5498
3d7a6b6a-ab29-4ddb-ad37-a37d9a462115	Lucy	Boadu Tabiri	lucyboadutabiri@gmail.com	0242177456	Doku	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	\N	\N	1985-02-06	Female	\N	Teacher	Eric Amadi Tabiri	0244813642	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-LUCY-9179
1937aa9c-bdad-410f-bfe2-f1206663a6e3	Akosua	Adjie-Darko	\N	0537600083	Alpha Lodge	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	\N	\N	2014-05-25	Male	\N	Student	Wilberforce Kwesi Darko	0244385268	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-AKOS-2338
c8478e46-3a58-4c25-bd65-3eeb82569eda	Mavis	Oforiwaa Ofori	\N	0240188400	Madina (Hannah school	Inactive	fbf94efe-df78-48c1-b28a-442e10ad9031	\N	/uploads/avatars/WhatsApp Image 2025-02-23 at 11.39.15.jpeg	\N	\N	\N	\N	\N	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-MAVI-9733
823c2591-5b77-4424-b570-0df46c721e21	Isaac	Agyemang	qwameisaac.2728@gmail.com	0549743504	lakeside	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-02-23	/uploads/avatars/Isaac Kwame Agyemang.jpeg	\N	1993-05-29	Male	Media	Businessman	Elizebeth Agyemang	0241382585	2026-05-16 18:32:13.788679+00	2026-05-17 10:16:56.463566+00	Other	Married	2021-08-28	Doris Hagan	Deceased	Joseph Agyemang	Alive	Elizabeth Agyemang	0241382585	t	2026-05-05	Rev. John B. Andah	Immersion	Temple Of Grace Baptist church	[{"dob": "2022-01-21", "name": "Kendrick Agyemang", "phone": ""}, {"dob": "2024-03-19", "name": "Quan Agyemang", "phone": ""}]	\N	["Mr."]	\N	TOGB-ISAA-1617
f963d716-3854-4098-a257-1146dfe969d3	Gloria	Korblah	gloriakorblah@gmail.com	0202623507	Pokuase, Odumasi	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/1000261560.jpg	\N	1988-07-30	Female	\N	Caterer	Irene Korblah	0555084152	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GLOR-1388
1200c2e5-3ae6-46a6-95db-0cdc8fe0e76c	LYDIA	KISSIWAA	\N	027795175	ADENTAN	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	/uploads/avatars/LYDIA KISSIWAA.jpeg	\N	1965-03-06	Female	\N	TRADER	HARRIET KISSI	0557231505	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-LYDI-8671
4f39e65c-d910-4ecf-9dd9-1b1e3b4bb69d	John	Baah	\N	0249834510	Botwe	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 11.48.08.jpeg	\N	1956-12-06	Male	\N	Church Staff	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-JOHN-9241
3ab78d50-5d91-4ae3-86be-cfc99210a01b	Raymond	Afedo	\N	0203176675	Madina (jfamco	Inactive	9710e588-06dc-47fa-9018-3ea28dc47a8d	\N	/uploads/avatars/WhatsApp Image 2025-02-23 at 11.42.05.jpeg	\N	\N	\N	\N	\N	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-RAYM-4794
3fe54343-795b-4233-90c9-c52af66de530	Esi	Botwe	\N	0245087290	Dome Abra	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 11.43.08.jpeg	\N	1979-09-11	Female	\N	Trader	Joseph Segoe	0243559222	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ESI-8073
e7688605-c595-48d7-908b-03c10b5bd178	Doreen	Afedo	\N	0552712721	Madina (jfamco	Inactive	9613f4af-4031-4043-85ff-8e0c85eae299	\N	/uploads/avatars/WhatsApp Image 2025-02-23 at 11.44.59.jpeg	\N	\N	\N	\N	\N	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DORE-2160
ea8a6816-6900-42e8-9266-9d604b2cff6c	Mary Korkor	Okyere	\N	0249608328	Mayehot	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	/uploads/avatars/1000261561.jpg	\N	1984-07-04	Female	\N	Seamstress	Florence Dapaa	0542780009	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Widowed	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-MARY-3196
850a0298-02bb-4829-91f5-1a796abeccae	Maame Akua	Sam	akuasam82@gmail.com	0552712509	Adentan	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 12.03.04.jpeg	\N	2002-12-25	Female	\N	Student	Annie Same	0243925930	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-MAAM-6951
c4565aed-41f5-4ee9-9f6c-aecd715f3bd3	GIFTY	DOGBE	\N	0591666896	ASHARLEY-BOTWE	Active	9613f4af-4031-4043-85ff-8e0c85eae299	\N	/uploads/avatars/GIFTY.jpeg	\N	1999-06-23	Female	\N	APPRENTICE (SEWING	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GIFT-8504
cbfc8393-5a69-499d-a69d-c6b869facbb6	Annie	Osei Sam	annieoseisam1973@gmail.com	0243925930	Adentan	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	/uploads/avatars/19 Annie Osei Sam.jpeg	\N	1973-03-23	Female	\N	Trader	Maame Akua Sam	0552712509	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ANNI-0878
1a5013a2-69d0-4212-a87e-79a7ce7cb242	Princess	Kwakye	pkwakye360@gmail.com	0539009519	Domeabra	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 11.54.43.jpeg	\N	2008-10-13	Female	\N	Student	Ama Nditsi	0544039864	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PRIN-2710
55c4d3ce-fa0a-4bf4-a02d-a48be1af724c	DAVID	BAAH TEYE	davidteye0080@gmail.com	0541162539	MAYEHOT-MADINA	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-02-23	/uploads/avatars/DAVID NEW.jpeg	\N	1983-05-28	Male	\N	PAINTER	ESTHER BAAH TEYE	0246657432	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DAVI-7628
1e17f47d-d29c-45ce-9a1f-72b836acc871	Victor	Adotey	adoteykwao@gmail.com	0209358122	Dansoman	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 12.04.13.jpeg	\N	1987-07-30	Male	\N	Businessman	Eunice Adotey	0263442637	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-VICT-9518
90cc8a0c-6e87-4bfe-a0b3-4144356e0a7b	Elvis	Apam	apamelvis321@gmail.com	0555113445	Nana Krom	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	\N	\N	2000-12-09	Male	\N	Student	Apam Beatrice	0554106820	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ELVI-6710
5737ceff-4382-4fdc-903c-a8acf04b5a1c	PALACE	AKAGLAH	\N	0244453492	DOMEABRA-MADINA	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-02-23	\N	\N	1974-08-25	Male	\N	ELECTRICIAN	COMFORT AKAGLAH	0243175313	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PALA-8328
b0549e2b-3f2f-4717-b0cc-7c02e8b4e61f	Comfort	Akaglah	\N	0243175313	Mayehot	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	/uploads/avatars/1000261579.jpg	\N	1979-11-16	Female	\N	Seamstress	Estherica Akaglah	0542223866	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-COMF-6501
a1df10d4-cb17-4bac-a61b-af1514d0dbdc	Victoria	Tawiah	tawiahvictoria76@gamil.com	0504884397	Domeabra	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 12.10.32.jpeg	\N	2004-07-30	Female	\N	Student	Portia Ampomah	0536353485	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-VICT-9654
a9d347c6-629d-4589-b387-fe023d856c10	Estherica Etornam	Akaglah	etornamestherica@gmail.com	0206947030	Mayehot	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/1000261581.jpg	\N	2007-01-16	Female	\N	Student	Comfort Akaglah	0243175313	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ESTH-2178
29011c27-0167-423a-b3a7-3ce35bbe29df	Georgina	Mallet	\N	0243414645	Oyarifa	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	\N	\N	1954-11-08	Female	\N	Retired	Joseh Mallet	0544473386	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Widowed	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GEOR-4880
19c38e9a-4fd7-4a9d-91a9-50bb33282fc9	ELIZABETH	ADAWINA	elizabethadawina59@gmail.com	0547420220	KIRAVIS - MADINA	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/ELIZABETH.jpeg	\N	1992-09-13	Female	\N	SALES PERSON	DORCAS NCHOI	0248876640	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ELIZ-0073
01b34eb0-fce8-4b27-89eb-95b1b73c9e7c	Sophia	Amoah	sophiaamoah085@gmail.com	0244697412	Oyibi	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-02-23	/uploads/avatars/1000261583.jpg	\N	1957-08-11	Female	\N	Retiree	Steven Amoah	0248191669	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-SOPH-5042
f382d183-d713-4666-8a72-83b62ac3958e	Getrude	Opoku	gertrudeopoku12@icloud.com	0257610112	Madina Domeabra	Active	9613f4af-4031-4043-85ff-8e0c85eae299	\N	/uploads/avatars/WhatsApp Image 2025-02-23 at 12.11.53.jpeg	\N	1995-04-04	Female	\N	Teacher (Safari International School	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GETR-9161
09e4bae0-1258-4652-8407-ce1d37def33e	Richael	Esenam Anku	richaelesenam@gmail.com	0509903881	Rawlings Circle	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 12.18.18.jpeg	\N	2008-07-06	Female	\N	Student	Mildred Aba-Quainoo	0593327419	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-RICH-1682
a3059fa3-3727-4254-a312-0940599f7989	Joyce Adjeley	Adjei	adjeleyjoyce00@gmail.com	0279979211	Domeabra	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 12.21.52.jpeg	\N	2003-06-20	Female	\N	Student	Comfort Otinkorang	0248255776	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-JOYC-4545
f8a17029-24bc-411b-8d3a-a9de6759d72f	Sedinam Yawa	Seshie	sedisesh@gmail.com	0207802413	Nsakina	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/1000261593.jpg	\N	1989-03-02	Female	\N	Administrator	Kwame Seshie	0545059377	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-SEDI-2240
c02a7842-dc23-4870-b915-1402b028fcec	Josephine  Delali	Wuaku	\N	0208268470	Madina Domeabra	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/Josephine Mallet.jpeg	\N	2001-02-09	Female	\N	Student	Rejoice Afenya	0551743905	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-JOSE-3978
de464eff-2633-4b6b-96e3-3937d8d281c4	Grace	Wuaku	gracewuaku90@gmail.com	0201539437	Madina-kiravis	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 12.24.06.jpeg	\N	1997-02-22	Female	\N	Banker - loan officer	Cephas Wuaku	0203238376	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GRAC-2509
a6ab4421-77f3-4da8-ae52-8aa55b2e6733	Gloria	Agyapong	esiagyapong@gmail.com	0201189349	Ashale Botwe	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 12.27.10.jpeg	\N	1997-05-18	Female	\N	Admin	Francis Agyapong	0552919399	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GLOR-4592
557a2f32-a53f-4cda-8bce-3c20385eb1d7	NANA AFIA	OWUSU-AGYEKUM	owusuagyekumnaana@gmail.com	0200887433	ASHARLEY-BOTWE	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/NANA.jpeg	\N	1997-02-28	Female	\N	PHYSICIAN ASSISTANT	PASTOR KWESI OWUSU-AGYEKUM	0200316878	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-NANA-4760
7541ef49-4d11-450b-b695-6308036f0e00	Grace	Botse	delaligrace71@gmail.com	0209165545	Kiravis	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 12.26.55.jpeg	\N	2000-06-29	Female	\N	National Service Personnel	Doris Elo	0247684520	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GRAC-5303
b8e11d03-2a7c-44ac-88dc-1f5d1ddcdd82	Rebecca Tiwaa	Acheampong	beccatiwaa@gmail.com	0546620632	Ritz hotel	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/1000261585.jpg	\N	1997-04-12	Female	\N	Secretary	Philip Awuah Acheampong	0546948285	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-REBE-1825
73279121-a695-4739-adc5-f812a1ad949b	Mawuli	Wuaku	mawuliwuaku@gmail.com	0203238376	Madina	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 12.33.47.jpeg	\N	1999-08-12	Male	\N	Bank Official	Rejoyce Afenya	0551743905	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-MAWU-5213
76c384b6-6482-40ea-a0d8-3f3f0c927b0b	Princess Erwina	Ndom	princessndom@gmail.com	0574341792	Madina Social Welfare	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/1000261595.jpg	\N	1994-11-11	Female	\N	Communication Practitioner	Lord Ndom	0279979079	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PRIN-8023
eb325999-ed50-4030-a8a7-a2b83699d9c9	Mildred	Quainoo	\N	0593327419	Madina Rawlings circle	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/WhatsApp Image 2025-02-23 at 12.39.54.jpeg	\N	1994-03-03	Female	\N	Self Employed	Ekow Bonzie	0244662887	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-MILD-0135
483c3f4a-c9b4-4321-a32b-d71c4e09a9b9	GENEVIEV	QUARSHIE	genevievquarshie123@gmail.com	0559772840	MAYEHOT-MADINA	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	/uploads/avatars/1000261603.jpg	\N	2004-07-11	Female	\N	STUDENT	CHRISTIANA NUTEKPOR QUARSHIE	0242711718	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GENE-1248
b1ed48af-43ba-4d41-b1a7-cc58786da385	FRED	OKLEY	fredokley412@gmail.com	0550100412	Madina Domeabra	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-24	\N	\N	2002-11-02	Male	\N	SELF EMPLOYED	ERNEST OKLEY	0554295004	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-FRED-3146
a97021f8-3da6-4857-b524-63a609dd6b92	Leticia	Agyapong	\N	0500400435	Botwe New Town	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Leticia Agyapong.jpeg	\N	1965-10-24	Female	\N	Retired	Josiah Agyapong	0545426855	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-LETI-3543
492e569d-5eda-4a94-91f3-200b53ea783b	Francis	Agyapong	frankofi78@gmail.com	0552919399	Oyarifa	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-02	\N	\N	1994-01-07	Male	\N	Banker	Josiah Agyapong	0545426855	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-FRAN-9109
2e22c90d-acb3-44a1-a7a3-e1bd2ba24c65	Abdallah	Yakubu	\N	0545479834	Madina Domeabra	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-02	\N	\N	2001-10-14	Male	\N	IT personnel	Magaret Acheampong	0245216175	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ABDA-8317
52e91250-9803-4de5-825d-0cc19865a403	Helena	Addo-Sunu	\N	0241993616	Madina Domeabra	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-02	/uploads/avatars/67c43e4b12afd.jpg	\N	1991-02-04	Female	\N	Staff at Express Gas	Serlom Solomon	0502383425	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-HELE-5524
59a269e0-8c74-41bd-8247-121a0b71e197	Vida	Kumiwaa Owusu	vidakumiwaaowuwsu@gmail.com	05526233725	Mayehot	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-02	/uploads/avatars/Vida Kumiwaa Owusu.jpeg	\N	1995-02-25	Female	\N	web Developer	Evans Dawa	0558043139	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-VIDA-4919
e17d2765-4435-487a-beb0-646cf304f8af	Vida	Kadzi	\N	0240532409	Mempeasem	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Vida.jpeg	\N	1973-01-12	Female	\N	Janitor	Grace Sablah	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-VIDA-8782
2a99eb4e-9244-4a1e-bb37-fe0170093eca	Grace	Sablah	\N	0246131045	Behind Church	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Grace Asabrah.jpeg	\N	1978-01-10	Female	\N	Tailor / Trader	Seth Sablah	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Divorced	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GRAC-7786
b9ae6d7c-f186-448f-a3ec-2a156008436e	CHARLOTTE	OFORIWAH	\N	0244080571	MADINA - MAYE HOT	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Charlotte Oforiwaa.jpeg	\N	1981-04-15	Female	\N	SEAMSTRESS	ERNEST ARYEE	0244662426	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-CHAR-7043
a8993904-26ea-41a9-94ab-babc43f58e4a	Felicia	Baidu	\N	0548851494	Aviation	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Felicia Boadu.jpeg	\N	1968-07-11	Female	\N	Trad	Frankl Eshun	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-FELI-5030
d2fcdf05-94e3-48f0-8667-77c96c805d4e	ANITA	OCLOO	oclooanita220@gmail.com	0555668227	Madina - Ritz	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-02	/uploads/avatars/Anita Ocloo.jpg	\N	1998-05-27	Female	\N	NURSE	ALICE ASSIBU	0547312201	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ANIT-8317
321d8e81-30f7-4028-9341-71d9d84f720d	Paulina	Awuah	\N	0595013368	Domeabra	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	\N	\N	1978-09-19	Female	\N	Catere	David Amenuvor	0557602364	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PAUL-8002
ef836240-6d97-4b90-8494-a802583e2ac0	Vida	Larbi	\N	0507041003	Madina	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Mrs Vida Larbi.jpeg	\N	1965-04-05	Female	\N	Chef	Mr. LArbi	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-VIDA-2328
9423096e-a41e-4d69-b66b-b062bd410101	REBECCA	OCLOO	\N	0546692877	Madina - Ritz	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Rebecca Andah.jpeg	\N	1965-06-23	Female	\N	BUSINESSWOMAN	ANITA OCLOO	0555668227	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-REBE-2525
81bb79b0-480b-478b-b14c-063607091beb	David	Amenuvor	\N	0557602365	Domeabra	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-02	/uploads/avatars/Mr Amenuvor.jpeg	\N	1966-06-13	Male	\N	Trader	Paulina Awuah	0595013368	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DAVI-5372
8b82868d-48f0-4ffd-866c-e0dfa48d22be	Grace	Yeboah	\N	0248149501	Pantang	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Grace Yeboah.jpeg	\N	1984-07-24	Female	\N	Trader	Esther Adu	0538666034	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Divorced	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GRAC-9972
3154df9a-e33d-4ff9-a08c-8fd230b4346d	Monica	Osei	\N	0248595964	Domeabra	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Monica Osei.jpeg	\N	1988-06-14	Female	\N	Trader	Uncle Willie	0246017057	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-MONI-1130
332bcc1e-fb07-4e98-9979-c49f640b9787	ERNESTINA	ALORSEY	\N	0558478310	MADINA - YELLOW SIGNBOARD	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Ernestina.jpeg	\N	1972-08-18	Female	\N	BUSINESSWOMAN	PRISCILLA BOATENG	0500367183	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ERNE-0974
6f4d2031-b1be-4c7f-b714-9d9112112f8b	Esinam	Owusu Adjie	\N	0249518615	Maye Hot	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Esinam Adjei.jpeg	\N	1986-04-20	Female	\N	Business Woman	Derrick Owusu	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ESIN-4497
1c73ddd4-ba9c-4465-9076-86eadeef84a6	RAYMOND	AAMASSA	\N	0509820450	BOTWE OLD TOWN	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-02	/uploads/avatars/Raymond Gamassah.jpeg	\N	1995-12-05	Male	\N	CARPENTER	GIFY AAMASSA	0547775499	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-RAYM-4214
7b9d26ed-1f2b-4a5e-8649-0d68278fbec2	Catherine	Hoffman	cmaddo@hotmail.com	0501260905	Trasacco West	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Catherine Hoffman.jpeg	\N	1957-10-16	Male	\N	Retirer	Dr. Justice Hoffman	0208123045	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-CATH-8670
79e3c98f-d9e7-4e8f-8e22-d3172a0a42a0	Kwame Dzisah	Seshie	kdseshie@gmail.com	0545059377	HSE NO 531 NSAKINA, AMASAMAN	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-02	\N	\N	1993-11-27	Male	\N	SELF EMPLOYED	JOSHUA OCLOO SESHIE	0244922945	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-KWAM-7212
722983c5-ad69-4d13-81fd-390faea9396b	Victoria	Annan	\N	0597100108	Lake side	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	\N	\N	1967-04-26	Female	\N	Trader	Benjamin Andah	0243271148	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-VICT-0018
c8c275cd-46d9-4846-9e0f-30f0284773e2	Rejoice	Afenya	\N	0551743905	Dome Abra	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	/uploads/avatars/Rejoyce Afenya.jpeg	\N	1971-07-08	Female	\N	Baby Sitter	Grace Wuaku	0201539437	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Widowed	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-REJO-9861
0a164860-fc62-4503-baf1-4abd5c9378b2	SAMUEL	KOJO ANNAN	\N	0554484821	OYARIFA	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-02	/uploads/avatars/Samuel Annan.jpeg	\N	1984-07-06	Male	\N	EVANGELIST / CHURCH WORKER	JOSPHINE AMAKUGI	0534211985	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-SAMU-0028
28e133e4-fec1-49f5-9ed0-e38c376790d5	Beatrice	Apam	beatriceapam7@gmail.com	0554106820	Chickweed St. Madina	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-02	\N	\N	1972-05-20	Female	\N	Caterer	Martin Apam	0246906330	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-BEAT-0202
23a245c1-b458-4cb9-854d-c796401a5b12	Calvin	Kortey Dua	calvinkorteywk@gmail.com	0538240399	Madina,Mayehot	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-02	/uploads/avatars/Calvin Kortey Dua.jpeg	\N	2006-12-19	Male	\N	Student	Isaac Adamtey Dua	0244112627	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-CALV-3432
3e00018a-6c46-499f-8cbd-40704e68adcd	Eric	Nutekpor	nutekpor@yahoo.com	0542071082	Maye hot	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-09	/uploads/avatars/Eric Nutekpor.jpeg	\N	1979-11-30	Male	\N	SELF EMPLOYED	0242711718	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ERIC-7058
29ed463f-8e70-4baf-9aaf-e27fa3c60c04	Angela	Boafo	\N	0542181725	Domeabra	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-09	/uploads/avatars/Angela Boafo.jpeg	\N	1992-03-28	Female	\N	SELF EMPLOYED	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ANGE-5140
eb6bb4b3-d534-4e70-adeb-5f6eb1a91624	Evelyn	Adzomani	\N	0242806348	Masalachi	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-09	/uploads/avatars/Evelyn.jpeg	\N	1981-10-31	Female	\N	none	0556299218	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-EVEL-6116
845db75d-e49b-4787-9c4a-1e5ea3a7c4f6	Comfort	Otenkrong	\N	0248255776	Mayehot	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-09	/uploads/avatars/Comfort Otenkrang.jpeg	\N	1970-01-09	Female	\N	Rrader	Gifty Tetteh	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Widowed	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-COMF-0902
3c11fa04-a872-42f6-921c-3deeac241bb1	Ernestina	Tetteh Tekper	\N	0208223909	Botwe New Town	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-09	/uploads/avatars/Erniestina Tekpeh.jpeg	\N	1957-05-11	Female	\N	Retired	Kwesi Owusu-Agyekum	020316878	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ERNE-8392
8a0b77af-4924-4fae-bc62-007315b78038	Edwina Eli	Mortty	elibilo813@gmail.com	0242586764	Baba yara	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-09	/uploads/avatars/Eli.jpeg	\N	1985-12-30	Female	\N	Teacher	Gladys Lumor	0593700140	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-EDWI-7973
29daf7e9-b3b4-462b-b7fb-b933ccfb05e8	Cyntia	Appiah	\N	0544662317	Aviation	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-09	\N	\N	1981-09-23	Female	\N	Trader	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-CYNT-5263
f179b035-fcc5-4453-bd8f-64d8320ec49f	Felicia Akumaning	Bruce	\N	0558371935	Damfa	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-09	/uploads/avatars/Felicia Bruce.jpeg	\N	1982-05-28	Female	\N	Hair dresser	Daniel Bruce	0246186210	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-FELI-7340
e4b9ae7d-0662-4828-a4a9-354dd9466c81	Getrude	Aba Moley Andah	andahgetrude@gmail.com	0545562085	Lakeside	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-09	/uploads/avatars/Gertrude Andah.jpeg	\N	1995-04-05	Female	\N	Civil Servant	Priscilla Annangfio	0244916725	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GETR-7003
766ce7ff-30a1-4633-9032-ff0e0db408d3	Rebecca	Gawu	\N	0246705256	Baba Yara	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-09	/uploads/avatars/Rebecca Gahu.jpeg	\N	1973-07-06	Female	\N	Trader	Ransford Tettey	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-REBE-3196
49f5be2a-7a17-4a58-9693-5ab25c20f180	Priscilla	Anangfio	priscillaandah2@yahoo.com	0244916725	East Legon Hills	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-09	/uploads/avatars/Priscilla Annanfio.jpeg	\N	1989-01-07	Female	\N	Customer Service	Richard Anangfio	0244046525	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PRIS-7348
6f7f1659-ef46-47cf-b348-1ac073d296bf	Christiana Adzo	Nutekpor	\N	0242711718	Maye hot	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-09	/uploads/avatars/Christiana Nutekpor.jpeg	\N	1968-12-23	Female	\N	Self employed	Genevive Quarshie	0208937237	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Divorced	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-CHRI-7606
4b0b692b-4d75-4a4d-a9d3-60d9d0e0762d	Esi	Sagoe	\N	0243153395	Tseado	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-09	\N	\N	1960-05-15	Female	\N	Trader	Efua Kitson Amoah	0208490129	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ESI-6199
b35e8c1b-f1be-432e-8e10-ece63b1a2d35	Emmanuel	Asante	kwekuasante09@gmail.com	0266664251	Baba yara	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-09	/uploads/avatars/Emmanuel Kwaku Asante.jpeg	\N	1985-07-01	Male	\N	Church Administrator	Barbara Prah	0243364241	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-EMMA-8450
57a4f42b-8e18-40d0-90bf-51bccc98b283	DANIEL	LAMPTEY	d6830705@gmail.com	0278584806	MADINA SOCIAL WELFARE	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-16	/uploads/avatars/5 Daniel Lamptey.jpeg	\N	1971-05-07	Male	\N	BUSINESS MAN	EBENEZER LAMPTEY	0592803465	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DANI-7762
7e6cfe2a-5f10-46a6-8db9-b3cadd052fb9	Elizabeth	Kpeglo	\N	0559407490	Botwe New Legon	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-16	/uploads/avatars/9 Elizabeth Kudzorji.jpeg	\N	1966-02-12	Female	\N	Trader	Derrick	0550295943	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ELIZ-7157
6ef1b01d-0a7d-4e1d-a1ea-4655b7edeffb	DORA	OTCHERE	yaadora347@gmail.com	0205419354	MADINA MAYE HOT	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-16	/uploads/avatars/13 Dora Okyere.jpeg	\N	1965-12-12	Female	\N	Trader	LETICIA	0257206051	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DORA-0844
2d732bbd-a8ba-4435-86f2-8dfb9534f364	Janet	Awuku	\N	0246259490	Madina Taxi Rank	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-16	/uploads/avatars/14 Janet Awuku.jpeg	\N	1972-02-22	Female	\N	Trader	Seth Amponsah	0241116278	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-JANE-8467
b21722c1-a018-41fd-962e-5c348431be92	Cynthia	Ametepey	\N	0535203830	Baba Yara	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-16	/uploads/avatars/16 Cynthia Ametepe.jpeg	\N	1976-02-29	Female	\N	Trader	Sarah Dogbe	0551347155	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-CYNT-9391
39953c5a-b893-4c55-834d-dac964a818c3	EKOW	BONDZI	\N	0244662887	NEW LEGON MARKET ELECTORAL COMMISION	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-16	/uploads/avatars/3 Ekow Bondzie.jpeg	\N	1964-04-02	Male	\N	TRADER	Veronica	0244656985	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-EKOW-5979
8a4f4540-c8de-441c-bd86-fe7b91c20323	Odei Samuel	Larbi	\N	0242630551	Teiman	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-16	/uploads/avatars/Samuel Larbi.jpeg	\N	1962-08-08	Male	\N	Mason	Emmanuel Larbi	0557383404	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ODEI-7306
f4ebfc6f-a448-409b-884d-7127ec2c57ed	Edith	Gyimah	\N	0245641787	Madina Social Welfare	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-16	/uploads/avatars/6 Edith Gyimah Okyere.jpeg	\N	1983-11-07	Female	\N	Trader	Richard Okyere	0249871365	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-EDIT-3772
3e55612d-2531-4eda-b2af-d769a7bea848	Evelyn	Akoto	\N	053337461	Botwe Old Town	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	\N	/uploads/avatars/12 Evelyn Akoto.jpeg	\N	1988-04-18	Female	\N	Trader (Cloth	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-EVEL-3431
09cf34bb-9abd-4881-85ec-b4d68885cc14	Asare	Kingsford	\N	0244018620	Madina Maye Hot	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-16	/uploads/avatars/4 Kingsford Asare.jpeg	\N	1962-09-15	Male	\N	Business Man	Georgina Asare	0242202575	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ASAR-7710
0c432650-ded6-49d9-8004-21d768416ddd	Patience	Kabu Afiyo	\N	0546523880	Around Church	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-16	/uploads/avatars/11 Patience Kabu.jpeg	\N	1994-08-20	Female	\N	Caterer	Prosper Kabu	0596505524	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PATI-3864
1d1e4c7a-ebae-411d-bd3b-5b68a5ac697c	Augustina	Teye Doku	\N	0542291996	Ogbojo New Market	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-16	/uploads/avatars/10 Augustina Duku.jpeg	\N	1990-10-10	Female	\N	Trader	Isaac Doku	0244476718	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-AUGU-2080
702bd143-a401-42d1-896e-22ef2a3fd949	Vida	Mensah	\N	0546181434	Around Church	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-16	\N	\N	1972-04-21	Female	\N	Trader	Emmanuel Adu Mensah	0243305206	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-VIDA-4118
a5dfb6e5-d973-473e-858b-6e801b9ee527	Benjamin	Hagan	\N	0547082910	Baba Yara	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-16	/uploads/avatars/Benjamin Hagan.jpeg	\N	1992-07-13	Male	\N	Electrician Trader	Joseph Hagan	0541633979	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-BENJ-2606
d97a12df-2af2-4b2b-8648-99b7f55c66ce	Gladys	Awudey	\N	0540808177	Around Church	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-16	/uploads/avatars/18 Gladys Awudey.jpeg	\N	1996-12-02	Female	\N	Caterer	Doris Awudu	0548669940	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GLAD-3088
eb5ea6cf-43f0-4b56-8387-ceb60eb983a5	Mrs. Agnes	Asana Ndom	\N	0208617022	Ogbojo light industrial area	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-16	/uploads/avatars/20 Agnes Asana Ndom.jpeg	\N	1963-06-20	Female	\N	Pharmacist	Rev. Emmanuel Ndom	0501886065	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-MRSA-5316
344bb812-1740-44c2-b805-e05dc1251850	Priscilla	Owusu-Agyekum	priscillaaduama2424@gmail.com	0543992264	Botwe New Town	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-16	/uploads/avatars/21 Priscilla Owusu Agyekum.jpeg	\N	1987-04-11	Female	\N	Teacher	Kwesi Owusu-Agyekum	0200316878	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PRIS-5713
4e60c612-31ec-4860-9da5-5e9df519e422	Leticia	Owusu-Ansah	\N	0257206051	Madina Maye Hot	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-16	/uploads/avatars/15 Leticia Ansah.jpeg	\N	1976-07-14	Male	\N	Trader	Prince Owusu Ansah	0543093025	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-LETI-3822
8e548ef7-27ef-4ea6-94b5-d675da63ac45	Prince	Owusu-Ansah	lyonlee350@gmail.com	0543093025	Madina Maye Hot	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-16	/uploads/avatars/22 Prince Owusu Ansah .jpeg	\N	2004-07-20	Male	\N	Web Developer and Designer	Leticia Owusu Ansah	0257206051	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PRIN-2959
0d7121d0-0eb8-4677-9820-44a3bbebb1e8	ERNEST TETTEY	OKLEY	\N	0554295004	Madina - Kiravis	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-16	\N	\N	2000-08-02	Male	\N	LAB-TECH	LYDIA KWAPONG	0249108156	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ERNE-5492
ad24d99c-f45b-40d0-ba0a-bad64197a0f6	Emmanuel	Hammond	niiaduhammond@gmail.com	0243194676	Botwe	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-23	\N	\N	1994-06-09	Male	\N	Accountant	Agnes Setordjie	0557311318	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-EMMA-1670
abc78384-b7a9-4ae5-ad41-97ca413f2b6c	Salomey	Akrofi	\N	0249646431	Domeabra	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-23	\N	\N	1983-05-15	Female	\N	Beautician	George Akrofi	0244947228	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-SALO-3564
a1e30027-2224-459d-9997-21db801299df	Doris	Jonah	\N	0509560176	Akosombo Junction	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-23	\N	\N	2003-04-12	Female	\N	Hairdresser	Jonah	0205396308	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DORI-4017
90757db1-a8c4-4987-ac56-546d02418fdb	Emmanuel	Folivi	\N	0571002007	Amanfroam Dodowa Road	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-23	\N	\N	1964-03-05	Male	\N	Carpenter	Esther Folivi	0550517435	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-EMMA-3829
430f19de-729d-4e2b-ae19-f9b3f8c0a4b7	Rose	Adom	\N	none	Ritz Hotel	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-23	\N	\N	1989-06-12	Female	\N	Trader	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ROSE-4573
79d4a82e-85a1-4a95-8626-8c1fd2614bf1	John	Asare-Addy	dadakojoasare@gmail.com	0577085707	Doku Opposite Lily of The Roses School	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-23	\N	\N	1991-04-01	Male	\N	Finance Officer	Mary Asare Addy	0547438578	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-JOHN-9802
67ff6252-e861-4b39-8343-df5f372972fd	Ama	Eshun	\N	0545215533	Madina Masalachi	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-23	\N	\N	1968-08-15	Female	\N	Cateerer	Josiah Agyapong	0545426855	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-AMA-2890
64a1c31b-13bf-4528-ab1e-c0be670bdf23	Isaac	Mawudzo	\N	0243636502	Doku	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-23	\N	\N	1966-09-28	Male	\N	Administrator	Juliet Mawudzo	0557115059	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ISAA-6227
282244ec-4c3b-42a0-b0dd-39e6e7117c0e	Bright Koffi	Saah	\N	0244101252	Domeabra Road	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-23	\N	\N	1970-05-05	Male	\N	Building and Construction	Eric Saah	0545165837	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-BRIG-3295
99bf4eaa-89ba-46c6-9995-7a3a121ce921	Vida	Boateng	\N	0249406638	Doku	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-23	\N	\N	1974-12-20	Female	\N	Trader	Isaac Mawudzo	0243636502	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-VIDA-1737
2729f660-db7a-4051-a305-48174554f083	Mary	Mamele	\N	0246612273	Kekele	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-23	\N	\N	1975-05-05	Female	\N	Trader	Henry Nartey	0243589298	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-MARY-9281
3f88d30f-02b5-4518-99c6-761cd54ae98b	Stephanie	Dorgbley	stephaniedogbley@gmail.com	0209876758	Kiravise	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-23	\N	\N	2007-03-11	Female	\N	Student	Patience Dorgbley	0591867447	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-STEP-1139
6674d357-ed7d-44ca-8733-0e594d614324	Priscilla	Amponsa	\N	0245790369	Around Church	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-23	\N	\N	1979-10-11	Female	\N	Trader	Patience Dorgbley	053496831	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PRIS-3794
ad2bea2c-f718-400e-8507-f64d2c28cfa5	Henry	Nartey	\N	0243589298	Kekele	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-23	\N	\N	1976-12-20	Male	\N	Carpenter	Mary Mamele	0246612273	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-HENR-7960
f658ca05-fc7a-4e3c-b094-edc6600d1c6e	Esther	Abena Nartey	\N	0243589298	Kekele	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-23	\N	\N	2008-12-23	Female	\N	School	Henry Nartey	0243589298	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ESTH-9470
a2d22d43-a742-49b9-948f-1e995d12bba8	Gideon	Kwabena Gli	\N	0242989368	Domeabra	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-23	\N	\N	1975-08-25	Male	\N	Carpenter and Farmer	Daniel Gli	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GIDE-1577
79498ac3-0972-48bf-a9ff-4fa7bda30b07	Isaac	Okuffo	\N	0241445652	Oyibi Sasabi	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-23	\N	\N	1968-11-17	Male	\N	Electronic Technitian	Fuatina Akua	0552136530	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ISAA-2219
51050761-60bd-47e6-a518-b1ec1ee09dd0	Emmanuel	Abeku	neovanno1@gmail.com	0277741689	Opposite Domeabra	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-23	\N	\N	1992-04-01	Male	\N	Merchant	Erangeline Dowwna-Sai	0542522227	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-EMMA-9065
cfa5832e-c69e-4152-87b7-e87946beebdc	Edith	Asemsro	\N	0543341897	Mayehot	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-23	\N	\N	1986-05-05	Female	\N	Trader	Bernice Agbeme	0549793462	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-EDIT-3880
664308ea-0b4a-450a-9898-3b21c5749759	Denis	Aseidu	\N	0557465443	Masalachi	Active	9613f4af-4031-4043-85ff-8e0c85eae299	\N	\N	\N	1986-06-17	Male	\N	Trader (Carpet	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DENI-4747
9027259f-32e3-48e4-9ceb-66b7e8f8e593	Sylvester	Dorgbley	\N	0245790369	Kiravis	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-23	\N	\N	2008-08-25	Male	\N	School	Priscilla Dorgbley	0245790369	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-SYLV-0063
6f769c38-a07b-41c2-8838-53c52d117326	Papa Kofi	Ampoma Sam	\N	0244204926	Aben woha	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-23	/uploads/avatars/23 Kofi Sam.jpeg	\N	2009-08-07	Male	\N	School	Annie Osei Sam	02423925930	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PAPA-9767
8640e4c5-f6f7-4b84-8e16-50763d80780f	Samuel Israel	Sai	\N	0543810533	May3 Hot	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-23	\N	\N	1957-09-04	Male	\N	Plumber/Electrician	Emmanuel	0244793052	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-SAMU-5804
cfbb034f-49e8-4a3c-ac82-76d927c7921c	Samuel	Owusu-Ansah	\N	0244440007	Madina Maye Hot	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-23	\N	\N	1973-04-07	Male	\N	Photographer	Prince Owusu-Ansah	0543093025	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-SAMU-5151
e5eec85a-9854-463f-8380-e1d0aa966b6b	Mrs. Nikita	Okine	\N	0541437123	Adenta Commandos	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-23	\N	\N	1988-08-19	Male	\N	Office Administrator	Mr. Michael Mawuli Okine	0243221815	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-MRSN-1221
6c1886fa-7042-499b-892f-64394eca060a	Debra	Kissi	\N	0554530903	Domeabra	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-23	\N	\N	1955-06-10	Female	\N	Trader	Edward Dwamena	0249584498	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DEBR-2436
d272875e-8fb4-45e7-bce6-54347c53a469	Alua	Theresa	\N	0234556678	Home Town: Navrongo	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-23	/uploads/avatars/7 Theresa Alua.jpeg	\N	1945-03-06	Female	\N	Pensioneer	John Alua	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ALUA-5751
df5cf448-66bf-428a-9a53-2f7d9a289388	Claude Charles Kafui	Ndom	claudendom@gmail.com	0279979079	Ogbojo light industrial area	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-23	\N	\N	1994-06-01	Male	\N	Student	Lord Ndom	0279979079	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-CLAU-2780
7e158b91-f64c-4dfd-93cc-060946a7ac0c	Rosemary	Twumwaa Annor	\N	0268116191	Kira Veez	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-28	\N	\N	1993-06-13	Female	\N	Business Development Consultant	Juliana Annor Yeboah	0241238882	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ROSE-9077
1833c410-3f2f-4479-aa0b-ed8e2e6c7d42	Bernice	Boakye-Kyeremeh	\N	0572749231	Madina	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-28	\N	\N	1995-05-06	Female	\N	Nurse	Kevin  Boakye-Kyeremeh	0243835942	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-BERN-3034
1b70864e-bdfd-4d91-bd8b-d90c633db1bf	Kevin	Boakye-Kyeremeh	\N	0243835942	madina	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-28	\N	\N	1984-05-29	Male	\N	Administrator	Bernice Boakye-Kyeremeh	0572749231	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-KEVI-5676
18457a39-e8c9-473c-a8e2-1a42754a3544	Christiana	Osei Bonsu	\N	0244515079	Adjacent the church - Doameabra	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-30	\N	\N	1964-01-20	Female	\N	Baker	Nana Kwame	0244121212	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-CHRI-6760
48ce2ddb-47e6-4885-9b9e-ebd3ea2fff73	Doris	Donkor	\N	0597203716	Masalachi, Friends of Little Ones School	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-30	\N	\N	1977-03-16	Female	\N	Trader	Fredrick Antwi Boateng	0592935785	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DORI-1205
1e22313b-3d66-4829-8004-d41d2b8d68e8	Churchill	Agbemehia Edem	churchillagbemehia@gmail.com	0598355882	Mayehot	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-30	\N	\N	2003-02-18	Male	\N	Student	Esinam Owusu	0249518615	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-CHUR-2190
580bcbff-5a27-4876-9782-a3befa5d4ded	Djaba	Teye	djabateye@hotmail.com	0243131861	No. 64 Nii Kodia Street Adenta	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-30	\N	\N	1992-08-12	Male	\N	Engineer	Djabakie Dede Teye	0542041642	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DJAB-9283
1f377c1b-6057-4ddc-b592-0b00112d8aac	Dede	Djabakie Teye	djabakieteye@hatmail.com	0542041642	Adentan	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-30	\N	\N	1994-07-03	Female	\N	Auditor	Djaba Teye	0243131861	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-DEDE-3970
6119a660-541d-473d-81f2-8045db431fe2	Bernice	Agbeme	\N	0549793462	Kira Veez	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-30	\N	\N	2007-09-23	Female	\N	Student	Edith Asemsro	0543341897	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-BERN-4319
9c0e6339-3978-4c7d-a9ea-97e191bcf250	Peace	Osayo	\N	0594515251	Dome Abra	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-30	\N	\N	1983-07-07	Male	\N	Cleaner	Ivy Sackeyteh	0500615517	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PEAC-3386
4d769a3a-3c05-47b2-9e22-b3736bba0ca3	Ivy	Sackeyteh	\N	0500615517	Dome Abra	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-30	\N	\N	2010-08-14	Female	\N	Student	Peace Osayo	0594515251	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-IVY-3434
228f56f7-1be6-4814-a0cf-7665b9d3556b	Juliet	Mawudzo	\N	0557115059	Kiravis	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-30	\N	\N	1993-05-19	Female	\N	Unemployed	Julius Mawudzo	0548512623	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-JULI-3140
31a092cb-bbc2-4200-8da4-2b078bc6336c	Albert	Owusu Sam	aldesam69@gmail.com	0244204926	66 Ayaben Street	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-30	\N	\N	1970-06-15	Male	\N	Businessman	Maame Akua Sam	0552712509	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ALBE-1745
4b34c2bb-5426-4d3d-83b1-5ab728661a1c	Blessing	Osei Owusu	blessingoseiwusu17@gmail.com	0500096691	Kiravis	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-30	\N	\N	2005-10-06	Female	\N	Student	Naomi Osei	Mother	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-BLES-5248
63f526bd-f519-446a-8214-dbb1781ee218	Helena	Nangena	\N	0547388902	Lakeside	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-30	\N	\N	1994-03-06	Female	\N	Trader	Joseph Oppong	024429734	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-HELE-3160
a5de1db3-4485-4a61-bb85-aa22b98ec5fb	Pamela	Teye	peakaba@gmail.com	0244926133	No. 64 Nii Kodai Street	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-30	\N	\N	1961-06-22	Female	\N	Pensioner	Djaba Teye	0243131861	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Widowed	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PAME-9320
3c198563-ad03-4a4b-8707-ffe7d85ba317	ISAAC	ADAMTEY DUA	iadua@ug.edu.gh	0268621082/024411262	MAYEHOT - MADINA	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-04-02	/uploads/avatars/67ed62613afd7.jpg	\N	1976-09-21	Male	\N	PERFORMING ARTIST - AUDIO-VISUAL ARCHIVIST	PHILOMINA AKU DUA	0243819931	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ISAA-0303
572779c2-4111-46b3-bef4-c72cba411f73	CALVIL	KORTEY DUA	\N	0538240399	MAYEHOT - MADINA	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-04-02	/uploads/avatars/67ed63e32f176.jpeg	\N	2006-12-19	Male	\N	STUDENT	ISAAC ADAMTEY DUA	0244112627	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-CALV-4813
e27ef668-59be-43b0-9636-4c8defd31f0f	MARY-EMILY	DEDE AWOSI DUA	\N	0505630689	MAYEHOT - MADINA	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-04-02	/uploads/avatars/67ed64ddc164e.jpeg	\N	2009-06-07	Female	\N	STUDENT	ISAAC ADAMTEY DUA	0244112627	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-MARY-8092
3c852cae-9028-4fa2-b602-111adb828642	ROBERTA	KORKOR DUA	\N	NONE	MAYEHOT - MADINA	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-04-02	/uploads/avatars/67ed658ddf9c2.jpeg	\N	2011-04-20	Female	\N	STUDENT	ISAAC ADAMTEY DUA	0244112627	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ROBE-2966
2e52b757-4145-4fd7-bf14-391d89012a72	PHILOMINA	AKU DUA	\N	0243819931	MAYEHOT - MADINA	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-04-02	/uploads/avatars/67ed6663c94fa.jpeg	\N	1981-09-30	Female	\N	TEACHER	ISAAC ADAMTEY DUA	0244112627	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PHIL-3347
1f8f698f-0e1f-4d20-9d01-c54a292a8136	Gifty	Ameo	\N	0555263987	Arapaje	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	\N	\N	\N	1994-10-29	Female	\N	Trader (Cloth	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Divorced	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GIFT-2319
b09167b0-15c5-4694-8c83-0aa6305b356a	GLORIA	DINA GASU	\N	0243927201	MADINA MAYE HOT	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-04-06	\N	\N	1972-06-09	Female	\N	CATERER	MARY GASU	0242834188	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GLOR-5732
a495b196-a900-4159-92e9-89ff880d9ade	Naomi	Osei	\N	0248581558	Kiravis	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-30	\N	\N	1970-07-07	Female	Member	unemployed	Sophia Osei	0247672168	2026-05-16 18:32:13.788679+00	2026-05-17 12:12:11.120097+00	Other	Widowed	\N	Cecilia Frimpong	Deceased	Kojo Antwi	Deceased	\N	\N	t	2026-05-06	Appiah	Immersion	Calvary	[{"dob": "1993-09-19", "name": "Sophia Osei", "phone": ""}, {"dob": "1998-09-29", "name": "Doborah Osei", "phone": ""}]	\N	["Mrs."]	\N	TOGB-NAOM-2547
fee688dc-ea79-4950-8ccf-e2d5029c6674	Sohia	Osei	sophiaosei09@gmail.com	0247672168	Kiravis	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-30	\N	\N	1993-09-09	Female	Member	Teacher	Naomi Osei	0248581558	2026-05-16 18:32:13.788679+00	2026-05-17 12:14:51.722983+00	Other	Single	\N	Naomi Osei	Alive	Emmanuel Osei	Deceased	\N	\N	t	2026-05-04	Null	Immersion	Pentecost	[]	\N	["Miss"]	\N	TOGB-SOHI-4322
ac2bd1c3-12c3-4226-8d2e-d9481e1cab9c	Agnes	Ahim	\N	0543952471	Ashale Botwe	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-04-06	\N	\N	1958-12-31	Female	\N	Trader	Erica	0267777313	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Widowed	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-AGNE-6021
7cadb7af-d315-4ae7-9b77-6e81f229719e	RITA	AMO	\N	0593745255	MADINA DOMEABRA	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-04-06	\N	\N	1983-10-10	Female	\N	TEACHER	DIVINE KUDJOE	0244854903	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-RITA-0868
0a311257-b3e6-46d1-9334-154071137b58	Melody	Tetteh	\N	0591432300	Adenta New site	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-04-06	\N	\N	1979-02-14	Female	\N	Business woman	Kwaku Sintim Boamah	0244738846	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-MELO-0396
8d4e9f90-99e2-4422-8368-a40c5eade008	GRACE	ADUBEA OWUSU	\N	0249292184	YELLOW SIGNBOARD - MADINA	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-04-06	\N	\N	1987-12-31	Female	\N	TEACHER	ISAAC OWUSU	0242647430	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-GRAC-1828
4f223147-1851-44eb-a8b7-a8ec5fad4d67	Paulina	Asantewaa	\N	0553103060	Neiborhood	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	\N	\N	\N	1965-03-10	Female	\N	Trader (Sea Food	\N	\N	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-PAUL-3954
62a4e24e-2d30-45b3-85e8-56410e51fe7a	Helena	Sackey	helenasackey@gmail.com	0248315441	Mayehot	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-04-06	\N	\N	1995-03-31	Female	\N	Cleaner	Dora Sackey	0553954552	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-HELE-8388
bb34473f-4aec-466e-99d2-f0ff9f9e9d0a	Joseph	Ablordey	\N	059003663	Madina Social Welfare	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-04-20	\N	\N	1972-02-14	Male	\N	Barber	Esther	0597958037	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-JOSE-7365
2bf30147-9244-45ae-a9fe-3a2e819776b3	Mercy	Afetogbor	\N	0545215321	Madina Domeabra	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-04-20	\N	\N	1976-12-31	Male	\N	Trader	Confidence Afetogbor	0273602627	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-MERC-8832
fc99d86f-038f-4f0b-b7d0-0c7093221a0f	Rita Edwina	Buckman	\N	0244247058	Alpha Lodge	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-04-25	\N	\N	1979-04-29	Female	\N	Businesswoman	Wilberforce Kwesi-Darko	0244385268	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Married	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-RITA-3326
871ab97d-5cb6-46e1-970e-deaaf426c70f	ABLEWORVI	TSIKATA	\N	0552601398	MAYEHOT	Inactive	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-04-27	\N	\N	1942-08-01	Female	\N	TRADER	Elikplim Gadri	573039830	2026-05-16 18:32:13.788679+00	2026-05-16 18:32:13.788679+00	\N	Widowed	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-ABLE-1549
7c8c1801-e8dc-49c1-9f43-45bb7fae5a54	Gloria	 Fudzi	\N	0597633551	Mayehot	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2026-05-24	\N	\N	2002-11-19	Female	Member	\N	Yaa	0550158349	2026-05-24 11:23:57.924281+00	2026-05-24 11:23:57.924281+00	Other	Single	\N	Mabel Kunadu	Alive	Daniel Fudzi	Alive	\N	\N	f	\N	\N	\N	\N	[{"dob": "2024-12-19", "name": "Sylvester Atta Kuma", "phone": ""}, {"dob": "2023-06-26", "name": "Treasure Atta Kuma", "phone": ""}]	\N	[]	\N	TOGB-GLOR-7757
3cba70fd-5cca-4724-ad9b-5fa1e0c3d1d5	Josiah	Agyapong	josiahiscoding@gmail.com	0545426855	Botwe New Town	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-23	\N	Cool bro	2001-02-23	Male	Media	Software Engineer	Gloria Agyapong	0541709968	2026-05-16 18:32:13.788679+00	2026-05-16 18:45:54.153166+00	Walk-In	Single	\N	Leticia Agyapong	Alive	Michael Agyapong	Alive	\N	\N	f	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-JOSI-0122
72d1de28-0984-4e32-87b6-cfdb4a158297	Lord Manuel Itu	Ndom	lordndom@gmail.com	0279979079	Ogbojo light industrial area	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-23	\N	\N	1996-06-27	Male	\N	Bespoke Tailor	Claude Ndom	0504650740	2026-05-16 18:32:13.788679+00	2026-05-16 19:06:13.585156+00	\N	Single	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	[]	\N	[]	\N	TOGB-LORD-4094
99e6de84-a042-4548-9b64-17069c2b327a	Mercy Adjo	Ahiabli	\N	0246407035	Powerland School	Active	fbf94efe-df78-48c1-b28a-442e10ad9031	2025-03-23	\N	\N	1977-10-10	Female	Member	Nursery Facilitator	James Afpenyo	0244096645	2026-05-16 18:32:13.788679+00	2026-05-17 12:06:02.192871+00	Other	Single	\N	Comfort Atinyi 	Deceased	Samuel Ahiabli 	Deceased	\N	\N	t	2026-05-05	Rev. John B. Andah	Immersion	Dome Abra	[]	\N	["Mrs."]	\N	TOGB-MERC-8151
9ee72074-a8db-4ba4-9dce-e3055f7b27f0	Deborah	Osei Owusu	oseiwusudeborah715@gmail.com	0503591721	Ashley-Botwe	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-03-30	\N	\N	1998-09-29	Female	Member	Beautician	Naomi Osei Owusu	0248581558	2026-05-16 18:32:13.788679+00	2026-05-17 12:08:07.708387+00	Other	Single	\N	Naomi Osei	Alive	Emmanuel Osei  Owusu	Deceased	\N	\N	f	\N	\N	\N	\N	[{"dob": "2020-07-07", "name": "Bernard Obeng", "phone": ""}, {"dob": "2019-07-07", "name": "Benjamin Obeng", "phone": ""}]	\N	["Miss"]	\N	TOGB-BEBO-4583
2f9c8a10-856b-4ed3-b94d-96aeb418c406	Joseph	Sagoe	\N	0243559222	Behind Church	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-09	\N	\N	1978-03-20	Male	Member	Carpenter	Peter Sagoe	0244891306	2026-05-16 18:32:13.788679+00	2026-05-17 12:21:16.71766+00	Other	Married	2025-05-23	Felicia Donkor 	Deceased	John Sagoe	Deceased	Esi Botwe	0245087290	t	2026-05-12	Null	Immersion	Church Of Pentecost	[{"dob": "2010-11-16", "name": "Erica Abena Sagoe", "phone": ""}, {"dob": "2012-09-01", "name": "Bismark Botwe Sagoe", "phone": ""}, {"dob": "2015-05-15", "name": "Solomon Atta Mensah Sagoe", "phone": ""}]	\N	["Mr."]	\N	TOGB-JOSE-8090
fea79e75-0898-4a37-89c9-662654b0bc30	Solomon	Doku	\N	0243027401	Volta Lane	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-16	\N	\N	1970-07-15	Male	Member	Mechanic refrigeration	Phedelia Tsatsu	0544629903	2026-05-16 18:32:13.788679+00	2026-05-17 12:23:11.368273+00	\N	Single	\N	Afi Azaglo	Deceased	Johnson Fomeka	Deceased	\N	\N	f	\N	\N	\N	\N	[]	\N	["Mr."]	\N	TOGB-SOLO-4394
cae05d96-e2f0-4cab-a1fa-415684d14c74	ALEX	Okley	\N	0276919402	Madina - Kiravis	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2025-03-16	/uploads/avatars/8 Alex Okley.jpeg	\N	1958-08-08	Male	Member	Fridge Mechanic	LYDIA	0249108156	2026-05-16 18:32:13.788679+00	2026-05-17 12:41:51.248703+00	Other	Widowed	\N	Mary Awusi	Deceased	Edward Okley	Deceased	\N	\N	t	\N	\N	\N	\N	[{"dob": "1986-10-02", "name": "Lydia Kwpong", "phone": "0249108156"}, {"dob": "20000-08-02", "name": "Ernest Okley", "phone": "0554295004"}, {"dob": "2002-11-02", "name": "Okley Fred", "phone": "0550100412"}, {"dob": "2007-05-12", "name": "Okley Arnold ", "phone": "0208472964"}]	\N	[]	\N	TOGB-ALEX-4190
f6dcbf5e-cf91-482d-868b-624507ce0f45	Vera	Mortey	morteyvera024@hmail.com	0509634768	Madina	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2025-02-24	\N	\N	1993-09-08	Female	Choir	Facilitator	Hannah Ofori Mortey	0539511555	2026-05-16 18:32:13.788679+00	2026-05-17 13:52:54.154375+00	Other	Single	\N	Hannah Ofori Mortey	Alive	Thompson Kofi Boney	Alive	\N	\N	t	2019-12-08	Rev. John B. Andah	Immersion	Temple Of Grace Baptist Church	[{"dob": "2013-10-07", "name": "Freda Eradwoa Mortey", "phone": ""}]	\N	[]	\N	TOGB-VERA-6631
19b052f7-7d36-4cf6-942b-a515d5687952	Arnold	Okley	Arnoldokley@gmail.com	0208472964	Ritz	Active	9613f4af-4031-4043-85ff-8e0c85eae299	2007-05-12	\N	\N	2007-05-12	\N	Media	Student	Fred Okley	0550100412	2026-05-17 12:32:41.897209+00	2026-05-24 10:56:27.596239+00	Other	Single	\N	Janet Okley	Deceased	Alex Okley	Alive	\N	\N	f	\N	\N	\N	\N	[]	Teye	[]	\N	TOGB-ARNO-1958
d923fa20-87a2-468d-abad-6d92a2f6db9d	Yaw	Boateng	\N	0553559640	Masalachi	Active	9710e588-06dc-47fa-9018-3ea28dc47a8d	2026-05-24	\N	\N	1969-01-01	\N	Member	Drive	Esther Dwomoh	0271761515	2026-05-24 11:17:32.872475+00	2026-05-24 11:17:32.872475+00	\N	Married	1992-03-14	Adowa Nkrumah	Deceased	Otoo Boateng	Deceased	Esther Dwomoh	0271761515	f	\N	\N	\N	\N	[{"dob": "0019-02-01", "name": "Esther Boateng ", "phone": ""}, {"dob": "1986-12-31", "name": "Augnes Boateng", "phone": "0540842232"}, {"dob": "1997-09-23", "name": "Enoch Boateng", "phone": "0549476397"}]	\N	["Mr."]	\N	TOGB-YAW-3960
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, content, channel, recipient_type, recipient_target, recipient_label, recipient_count, status, type, sent_at, sender_user_id, sender_role, sender_zone_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, name, applied_at) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description, permissions, is_system, created_at, updated_at) FROM stdin;
707bc6d0-94a4-4b3f-b24f-5aa4296148ec	admin	System Administrator with full access to all modules.	{"zones": {"edit": true, "read": true, "create": true, "delete": true}, "events": {"edit": true, "read": true, "create": true, "delete": true}, "members": {"edit": true, "read": true, "create": true, "delete": true}, "reports": {"edit": true, "read": true, "create": true, "delete": true}, "settings": {"edit": true, "read": true, "create": true, "delete": true}, "dashboard": {"edit": true, "read": true, "create": true, "delete": true}, "messaging": {"edit": true, "read": true, "create": true, "delete": true}, "attendance": {"edit": true, "read": true, "create": true, "delete": true}}	t	2026-05-16 16:29:08.24833+00	2026-05-16 16:29:08.24833+00
f13f8b80-ff7e-4c0a-8ed7-854fbbfab920	Pastorate	Pastors and reverends	{"zones": {"edit": true, "read": true, "create": true, "delete": true}, "events": {"edit": true, "read": true, "create": true, "delete": true}, "members": {"edit": true, "read": true, "create": true, "delete": true}, "reports": {"edit": true, "read": true, "create": true, "delete": true}, "settings": {"edit": true, "read": true, "create": true, "delete": true}, "dashboard": {"edit": true, "read": true, "create": true, "delete": true}, "messaging": {"edit": true, "read": true, "create": true, "delete": true}, "attendance": {"edit": true, "read": true, "create": true, "delete": true}}	f	2026-05-16 20:01:26.494923+00	2026-05-16 20:01:26.494923+00
\.


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.settings (id, key, value, updated_at) FROM stdin;
1	church_name	TOGBC	2026-05-16 20:03:13.787536+00
2	church_logo	data:image/png;base64,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	2026-05-16 20:03:13.794136+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password_hash, role, member_id, zone_id, created_at, updated_at, role_id, mfa_enabled, mfa_code, mfa_code_expires_at) FROM stdin;
dbf4d419-34c0-4228-b387-d065077fa7a9	Admin User	admin@example.com	$2b$10$gh8lwD7qNPxwibUq3WKADOaoFYXpAnIMDQHqxoba/EwSuUxNERDe6	admin	\N	\N	2026-05-16 16:29:08.345362+00	2026-05-16 16:29:08.345362+00	707bc6d0-94a4-4b3f-b24f-5aa4296148ec	f	\N	\N
75780854-67b6-4832-a470-b83509a42f1d	Lord Manuel Itu Ndom	lordndom@gmail.com	$2b$10$eKKH1CeWRhjFgoxG.wlfOeR7HuMJE7rM.srtnrnN9iTCg1BrCadcq	zone_leader	72d1de28-0984-4e32-87b6-cfdb4a158297	9613f4af-4031-4043-85ff-8e0c85eae299	2026-05-16 19:06:14.300684+00	2026-05-16 19:06:14.300684+00	\N	f	\N	\N
\.


--
-- Data for Name: zones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zones (id, name, leader, description, meeting_time, created_at, updated_at, leader_id) FROM stdin;
9710e588-06dc-47fa-9018-3ea28dc47a8d	Men's Ministry	\N	\N	Mondays 	2026-05-16 16:30:46.995864+00	2026-05-16 16:30:46.995864+00	\N
fbf94efe-df78-48c1-b28a-442e10ad9031	Women's  Ministry	\N	\N	Mondays	2026-05-16 16:31:22.884171+00	2026-05-16 16:31:22.884171+00	\N
9613f4af-4031-4043-85ff-8e0c85eae299	Youth Ministry	\N	\N	Tuesdays 6:30pm	2026-05-16 16:31:03.148024+00	2026-05-16 19:06:13.572547+00	72d1de28-0984-4e32-87b6-cfdb4a158297
\.


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 1, false);


--
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.settings_id_seq', 4, true);


--
-- Name: attendance attendance_instance_id_member_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_instance_id_member_id_key UNIQUE (instance_id, member_id);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- Name: event_instances event_instances_event_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_instances
    ADD CONSTRAINT event_instances_event_id_date_key UNIQUE (event_id, date);


--
-- Name: event_instances event_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_instances
    ADD CONSTRAINT event_instances_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: members members_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_email_key UNIQUE (email);


--
-- Name: members members_member_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_member_id_key UNIQUE (member_id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: settings settings_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_key_key UNIQUE (key);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: zones zones_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zones
    ADD CONSTRAINT zones_name_key UNIQUE (name);


--
-- Name: zones zones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zones
    ADD CONSTRAINT zones_pkey PRIMARY KEY (id);


--
-- Name: idx_attendance_instance; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_attendance_instance ON public.attendance USING btree (instance_id);


--
-- Name: idx_attendance_member; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_attendance_member ON public.attendance USING btree (member_id);


--
-- Name: idx_events_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_events_active ON public.events USING btree (is_active);


--
-- Name: idx_events_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_events_type ON public.events USING btree (type);


--
-- Name: idx_events_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_events_zone_id ON public.events USING btree (zone_id);


--
-- Name: idx_instances_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_instances_date ON public.event_instances USING btree (date);


--
-- Name: idx_instances_event; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_instances_event ON public.event_instances USING btree (event_id);


--
-- Name: idx_instances_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_instances_status ON public.event_instances USING btree (status);


--
-- Name: idx_members_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_members_email ON public.members USING btree (email);


--
-- Name: idx_members_marriage_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_members_marriage_date ON public.members USING btree (marriage_date);


--
-- Name: idx_members_member_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_members_member_id ON public.members USING btree (member_id);


--
-- Name: idx_members_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_members_name ON public.members USING btree (last_name, first_name);


--
-- Name: idx_members_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_members_status ON public.members USING btree (status);


--
-- Name: idx_members_zone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_members_zone ON public.members USING btree (zone_id);


--
-- Name: idx_messages_sender_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_sender_user_id ON public.messages USING btree (sender_user_id);


--
-- Name: idx_messages_sender_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_sender_zone_id ON public.messages USING btree (sender_zone_id);


--
-- Name: idx_messages_sent_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_sent_at ON public.messages USING btree (sent_at DESC);


--
-- Name: idx_messages_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_type ON public.messages USING btree (type);


--
-- Name: idx_users_member_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_member_id ON public.users USING btree (member_id);


--
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_role ON public.users USING btree (role);


--
-- Name: idx_users_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_role_id ON public.users USING btree (role_id);


--
-- Name: idx_users_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_zone_id ON public.users USING btree (zone_id);


--
-- Name: idx_zones_leader_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_zones_leader_id ON public.zones USING btree (leader_id);


--
-- Name: attendance attendance_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES public.event_instances(id) ON DELETE CASCADE;


--
-- Name: attendance attendance_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id) ON DELETE SET NULL;


--
-- Name: event_instances event_instances_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_instances
    ADD CONSTRAINT event_instances_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: events events_zone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_zone_id_fkey FOREIGN KEY (zone_id) REFERENCES public.zones(id) ON DELETE SET NULL;


--
-- Name: messages messages_sender_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_user_id_fkey FOREIGN KEY (sender_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: messages messages_sender_zone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_zone_id_fkey FOREIGN KEY (sender_zone_id) REFERENCES public.zones(id) ON DELETE SET NULL;


--
-- Name: users users_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id) ON DELETE SET NULL;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE SET NULL;


--
-- Name: users users_zone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_zone_id_fkey FOREIGN KEY (zone_id) REFERENCES public.zones(id) ON DELETE SET NULL;


--
-- Name: zones zones_leader_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zones
    ADD CONSTRAINT zones_leader_id_fkey FOREIGN KEY (leader_id) REFERENCES public.members(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict 7mtMZD9IHrfJXee1agm89hz5Ra2KzFsbGsN72MoqYFOhvcGgoBMRyDs8m3BKf89

