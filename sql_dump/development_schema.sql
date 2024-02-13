--
-- PostgreSQL database dump
--

-- Dumped from database version 11.3 (Debian 11.3-1.pgdg90+1)
-- Dumped by pg_dump version 14.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    rut character varying NOT NULL,
    email character varying NOT NULL,
    relation_id bigint NOT NULL,
    bank_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO postgres;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: action_mailbox_inbound_emails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.action_mailbox_inbound_emails (
    id bigint NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    message_id character varying NOT NULL,
    message_checksum character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.action_mailbox_inbound_emails OWNER TO postgres;

--
-- Name: action_mailbox_inbound_emails_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.action_mailbox_inbound_emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.action_mailbox_inbound_emails_id_seq OWNER TO postgres;

--
-- Name: action_mailbox_inbound_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.action_mailbox_inbound_emails_id_seq OWNED BY public.action_mailbox_inbound_emails.id;


--
-- Name: action_text_rich_texts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.action_text_rich_texts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    body text,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.action_text_rich_texts OWNER TO postgres;

--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.action_text_rich_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.action_text_rich_texts_id_seq OWNER TO postgres;

--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.action_text_rich_texts_id_seq OWNED BY public.action_text_rich_texts.id;


--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_admin_comments (
    id bigint NOT NULL,
    namespace character varying,
    body text,
    resource_type character varying,
    resource_id bigint,
    author_type character varying,
    author_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_admin_comments OWNER TO postgres;

--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_admin_comments_id_seq OWNER TO postgres;

--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.active_admin_comments_id_seq OWNED BY public.active_admin_comments.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO postgres;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_attachments_id_seq OWNER TO postgres;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO postgres;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_blobs_id_seq OWNER TO postgres;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.admin_users OWNER TO postgres;

--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_users_id_seq OWNER TO postgres;

--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: banks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.banks OWNER TO postgres;

--
-- Name: banks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.banks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.banks_id_seq OWNER TO postgres;

--
-- Name: banks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.banks_id_seq OWNED BY public.banks.id;


--
-- Name: dollar_prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dollar_prices (
    id bigint NOT NULL,
    price double precision NOT NULL,
    date timestamp without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.dollar_prices OWNER TO postgres;

--
-- Name: dollar_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dollar_prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dollar_prices_id_seq OWNER TO postgres;

--
-- Name: dollar_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dollar_prices_id_seq OWNED BY public.dollar_prices.id;


--
-- Name: investment_assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.investment_assets (
    id bigint NOT NULL,
    name character varying NOT NULL,
    asset_id character varying NOT NULL,
    currency integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    valid_asset boolean DEFAULT false,
    asset_type integer,
    is_custom boolean DEFAULT false,
    mtd double precision,
    recovery_level double precision,
    qtd double precision,
    ytd double precision,
    y1 double precision,
    y3 double precision,
    y5 double precision,
    sub_sector character varying,
    average_annual_cost double precision
);


ALTER TABLE public.investment_assets OWNER TO postgres;

--
-- Name: investment_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.investment_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.investment_assets_id_seq OWNER TO postgres;

--
-- Name: investment_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.investment_assets_id_seq OWNED BY public.investment_assets.id;


--
-- Name: ledgerizer_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ledgerizer_accounts (
    id bigint NOT NULL,
    tenant_type character varying,
    tenant_id bigint,
    accountable_type character varying,
    accountable_id bigint,
    name character varying,
    currency character varying,
    account_type character varying,
    mirror_currency character varying,
    balance_cents bigint DEFAULT 0 NOT NULL,
    balance_currency character varying DEFAULT 'USD'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.ledgerizer_accounts OWNER TO postgres;

--
-- Name: ledgerizer_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ledgerizer_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ledgerizer_accounts_id_seq OWNER TO postgres;

--
-- Name: ledgerizer_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ledgerizer_accounts_id_seq OWNED BY public.ledgerizer_accounts.id;


--
-- Name: ledgerizer_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ledgerizer_entries (
    id bigint NOT NULL,
    tenant_type character varying,
    tenant_id bigint,
    code character varying,
    document_type character varying,
    document_id bigint,
    entry_time timestamp without time zone,
    mirror_currency character varying,
    conversion_amount_cents bigint,
    conversion_amount_currency character varying DEFAULT 'USD'::character varying NOT NULL
);


ALTER TABLE public.ledgerizer_entries OWNER TO postgres;

--
-- Name: ledgerizer_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ledgerizer_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ledgerizer_entries_id_seq OWNER TO postgres;

--
-- Name: ledgerizer_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ledgerizer_entries_id_seq OWNED BY public.ledgerizer_entries.id;


--
-- Name: ledgerizer_lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ledgerizer_lines (
    id bigint NOT NULL,
    entry_id bigint,
    entry_time timestamp without time zone,
    entry_code character varying,
    account_id bigint,
    account_type character varying,
    account_name character varying,
    account_mirror_currency character varying,
    tenant_type character varying,
    tenant_id bigint,
    document_type character varying,
    document_id bigint,
    accountable_type character varying,
    accountable_id bigint,
    amount_cents bigint DEFAULT 0 NOT NULL,
    amount_currency character varying DEFAULT 'USD'::character varying NOT NULL,
    balance_cents bigint DEFAULT 0 NOT NULL,
    balance_currency character varying DEFAULT 'USD'::character varying NOT NULL
);


ALTER TABLE public.ledgerizer_lines OWNER TO postgres;

--
-- Name: ledgerizer_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ledgerizer_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ledgerizer_lines_id_seq OWNER TO postgres;

--
-- Name: ledgerizer_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ledgerizer_lines_id_seq OWNED BY public.ledgerizer_lines.id;


--
-- Name: ledgerizer_revaluations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ledgerizer_revaluations (
    id bigint NOT NULL,
    tenant_type character varying,
    tenant_id bigint,
    currency character varying,
    revaluation_time timestamp without time zone,
    amount_cents bigint DEFAULT 0 NOT NULL,
    amount_currency character varying DEFAULT 'USD'::character varying NOT NULL
);


ALTER TABLE public.ledgerizer_revaluations OWNER TO postgres;

--
-- Name: ledgerizer_revaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ledgerizer_revaluations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ledgerizer_revaluations_id_seq OWNER TO postgres;

--
-- Name: ledgerizer_revaluations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ledgerizer_revaluations_id_seq OWNED BY public.ledgerizer_revaluations.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.memberships (
    id bigint NOT NULL,
    sub_account_id bigint NOT NULL,
    investment_asset_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    hidden boolean DEFAULT false
);


ALTER TABLE public.memberships OWNER TO postgres;

--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.memberships_id_seq OWNER TO postgres;

--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.memberships_id_seq OWNED BY public.memberships.id;


--
-- Name: money_movements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.money_movements (
    id bigint NOT NULL,
    quotas integer NOT NULL,
    date timestamp without time zone NOT NULL,
    sub_account_id bigint NOT NULL,
    membership_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    movement_type integer,
    average_price double precision,
    deleted_by_id integer
);


ALTER TABLE public.money_movements OWNER TO postgres;

--
-- Name: money_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.money_movements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.money_movements_id_seq OWNER TO postgres;

--
-- Name: money_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.money_movements_id_seq OWNED BY public.money_movements.id;


--
-- Name: price_change_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_change_documents (
    id bigint NOT NULL,
    price_change_id bigint NOT NULL,
    membership_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.price_change_documents OWNER TO postgres;

--
-- Name: price_change_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.price_change_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.price_change_documents_id_seq OWNER TO postgres;

--
-- Name: price_change_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_change_documents_id_seq OWNED BY public.price_change_documents.id;


--
-- Name: price_changes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_changes (
    id bigint NOT NULL,
    value double precision NOT NULL,
    price_changed_at timestamp without time zone NOT NULL,
    investment_asset_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    money_movement_id bigint,
    from_file boolean DEFAULT false
);


ALTER TABLE public.price_changes OWNER TO postgres;

--
-- Name: price_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.price_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.price_changes_id_seq OWNER TO postgres;

--
-- Name: price_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_changes_id_seq OWNED BY public.price_changes.id;


--
-- Name: relation_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relation_files (
    id bigint NOT NULL,
    relation_id bigint NOT NULL,
    account_id bigint,
    sub_account_id bigint,
    bank_id bigint,
    name character varying,
    date date,
    document_type integer,
    file_data jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.relation_files OWNER TO postgres;

--
-- Name: relation_files_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.relation_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relation_files_id_seq OWNER TO postgres;

--
-- Name: relation_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.relation_files_id_seq OWNED BY public.relation_files.id;


--
-- Name: relation_histories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relation_histories (
    id bigint NOT NULL,
    relation_id bigint NOT NULL,
    time_window integer,
    wallet_values jsonb DEFAULT '{}'::jsonb NOT NULL,
    balances_values jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.relation_histories OWNER TO postgres;

--
-- Name: relation_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.relation_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relation_histories_id_seq OWNER TO postgres;

--
-- Name: relation_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.relation_histories_id_seq OWNED BY public.relation_histories.id;


--
-- Name: relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relations (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    rut character varying NOT NULL,
    email character varying NOT NULL,
    phone character varying,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    show_wallet boolean DEFAULT false
);


ALTER TABLE public.relations OWNER TO postgres;

--
-- Name: relations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relations_id_seq OWNER TO postgres;

--
-- Name: relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.relations_id_seq OWNED BY public.relations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: sub_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sub_accounts (
    id bigint NOT NULL,
    currency integer NOT NULL,
    sub_account_id character varying NOT NULL,
    account_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.sub_accounts OWNER TO postgres;

--
-- Name: sub_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sub_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sub_accounts_id_seq OWNER TO postgres;

--
-- Name: sub_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sub_accounts_id_seq OWNED BY public.sub_accounts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    phone_number character varying,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    institution character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: wallet_deposits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wallet_deposits (
    id bigint NOT NULL,
    sub_account_id bigint NOT NULL,
    date date,
    amount double precision,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    comment character varying
);


ALTER TABLE public.wallet_deposits OWNER TO postgres;

--
-- Name: wallet_deposits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wallet_deposits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wallet_deposits_id_seq OWNER TO postgres;

--
-- Name: wallet_deposits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wallet_deposits_id_seq OWNED BY public.wallet_deposits.id;


--
-- Name: wallet_withdrawals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wallet_withdrawals (
    id bigint NOT NULL,
    sub_account_id bigint NOT NULL,
    date date,
    amount double precision,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    comment character varying
);


ALTER TABLE public.wallet_withdrawals OWNER TO postgres;

--
-- Name: wallet_withdrawals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wallet_withdrawals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wallet_withdrawals_id_seq OWNER TO postgres;

--
-- Name: wallet_withdrawals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wallet_withdrawals_id_seq OWNED BY public.wallet_withdrawals.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: action_mailbox_inbound_emails id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_mailbox_inbound_emails ALTER COLUMN id SET DEFAULT nextval('public.action_mailbox_inbound_emails_id_seq'::regclass);


--
-- Name: action_text_rich_texts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN id SET DEFAULT nextval('public.action_text_rich_texts_id_seq'::regclass);


--
-- Name: active_admin_comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_admin_comments ALTER COLUMN id SET DEFAULT nextval('public.active_admin_comments_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- Name: banks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banks ALTER COLUMN id SET DEFAULT nextval('public.banks_id_seq'::regclass);


--
-- Name: dollar_prices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dollar_prices ALTER COLUMN id SET DEFAULT nextval('public.dollar_prices_id_seq'::regclass);


--
-- Name: investment_assets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investment_assets ALTER COLUMN id SET DEFAULT nextval('public.investment_assets_id_seq'::regclass);


--
-- Name: ledgerizer_accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledgerizer_accounts ALTER COLUMN id SET DEFAULT nextval('public.ledgerizer_accounts_id_seq'::regclass);


--
-- Name: ledgerizer_entries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledgerizer_entries ALTER COLUMN id SET DEFAULT nextval('public.ledgerizer_entries_id_seq'::regclass);


--
-- Name: ledgerizer_lines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledgerizer_lines ALTER COLUMN id SET DEFAULT nextval('public.ledgerizer_lines_id_seq'::regclass);


--
-- Name: ledgerizer_revaluations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledgerizer_revaluations ALTER COLUMN id SET DEFAULT nextval('public.ledgerizer_revaluations_id_seq'::regclass);


--
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memberships ALTER COLUMN id SET DEFAULT nextval('public.memberships_id_seq'::regclass);


--
-- Name: money_movements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.money_movements ALTER COLUMN id SET DEFAULT nextval('public.money_movements_id_seq'::regclass);


--
-- Name: price_change_documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_change_documents ALTER COLUMN id SET DEFAULT nextval('public.price_change_documents_id_seq'::regclass);


--
-- Name: price_changes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_changes ALTER COLUMN id SET DEFAULT nextval('public.price_changes_id_seq'::regclass);


--
-- Name: relation_files id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relation_files ALTER COLUMN id SET DEFAULT nextval('public.relation_files_id_seq'::regclass);


--
-- Name: relation_histories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relation_histories ALTER COLUMN id SET DEFAULT nextval('public.relation_histories_id_seq'::regclass);


--
-- Name: relations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations ALTER COLUMN id SET DEFAULT nextval('public.relations_id_seq'::regclass);


--
-- Name: sub_accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_accounts ALTER COLUMN id SET DEFAULT nextval('public.sub_accounts_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: wallet_deposits id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_deposits ALTER COLUMN id SET DEFAULT nextval('public.wallet_deposits_id_seq'::regclass);


--
-- Name: wallet_withdrawals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_withdrawals ALTER COLUMN id SET DEFAULT nextval('public.wallet_withdrawals_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: action_mailbox_inbound_emails action_mailbox_inbound_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_mailbox_inbound_emails
    ADD CONSTRAINT action_mailbox_inbound_emails_pkey PRIMARY KEY (id);


--
-- Name: action_text_rich_texts action_text_rich_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_text_rich_texts
    ADD CONSTRAINT action_text_rich_texts_pkey PRIMARY KEY (id);


--
-- Name: active_admin_comments active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: banks banks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banks
    ADD CONSTRAINT banks_pkey PRIMARY KEY (id);


--
-- Name: dollar_prices dollar_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dollar_prices
    ADD CONSTRAINT dollar_prices_pkey PRIMARY KEY (id);


--
-- Name: investment_assets investment_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investment_assets
    ADD CONSTRAINT investment_assets_pkey PRIMARY KEY (id);


--
-- Name: ledgerizer_accounts ledgerizer_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledgerizer_accounts
    ADD CONSTRAINT ledgerizer_accounts_pkey PRIMARY KEY (id);


--
-- Name: ledgerizer_entries ledgerizer_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledgerizer_entries
    ADD CONSTRAINT ledgerizer_entries_pkey PRIMARY KEY (id);


--
-- Name: ledgerizer_lines ledgerizer_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledgerizer_lines
    ADD CONSTRAINT ledgerizer_lines_pkey PRIMARY KEY (id);


--
-- Name: ledgerizer_revaluations ledgerizer_revaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledgerizer_revaluations
    ADD CONSTRAINT ledgerizer_revaluations_pkey PRIMARY KEY (id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: money_movements money_movements_average_price_null; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.money_movements
    ADD CONSTRAINT money_movements_average_price_null CHECK ((average_price IS NOT NULL)) NOT VALID;


--
-- Name: money_movements money_movements_movement_type_null; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.money_movements
    ADD CONSTRAINT money_movements_movement_type_null CHECK ((movement_type IS NOT NULL)) NOT VALID;


--
-- Name: money_movements money_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.money_movements
    ADD CONSTRAINT money_movements_pkey PRIMARY KEY (id);


--
-- Name: price_change_documents price_change_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_change_documents
    ADD CONSTRAINT price_change_documents_pkey PRIMARY KEY (id);


--
-- Name: price_changes price_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_changes
    ADD CONSTRAINT price_changes_pkey PRIMARY KEY (id);


--
-- Name: relation_files relation_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relation_files
    ADD CONSTRAINT relation_files_pkey PRIMARY KEY (id);


--
-- Name: relation_histories relation_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relation_histories
    ADD CONSTRAINT relation_histories_pkey PRIMARY KEY (id);


--
-- Name: relations relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT relations_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sub_accounts sub_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_accounts
    ADD CONSTRAINT sub_accounts_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wallet_deposits wallet_deposits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_deposits
    ADD CONSTRAINT wallet_deposits_pkey PRIMARY KEY (id);


--
-- Name: wallet_withdrawals wallet_withdrawals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_withdrawals
    ADD CONSTRAINT wallet_withdrawals_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_bank_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_accounts_on_bank_id ON public.accounts USING btree (bank_id);


--
-- Name: index_accounts_on_relation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_accounts_on_relation_id ON public.accounts USING btree (relation_id);


--
-- Name: index_action_mailbox_inbound_emails_uniqueness; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_action_mailbox_inbound_emails_uniqueness ON public.action_mailbox_inbound_emails USING btree (message_id, message_checksum);


--
-- Name: index_action_text_rich_texts_uniqueness; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_action_text_rich_texts_uniqueness ON public.action_text_rich_texts USING btree (record_type, record_id, name);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON public.active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_active_admin_comments_on_namespace ON public.active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON public.active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_admin_users_on_email ON public.admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON public.admin_users USING btree (reset_password_token);


--
-- Name: index_dollar_prices_on_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_dollar_prices_on_date ON public.dollar_prices USING btree (date);


--
-- Name: index_investment_assets_on_asset_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_investment_assets_on_asset_id ON public.investment_assets USING btree (asset_id);


--
-- Name: index_ledgerizer_accounts_on_acc_type_and_acc_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledgerizer_accounts_on_acc_type_and_acc_id ON public.ledgerizer_accounts USING btree (accountable_type, accountable_id);


--
-- Name: index_ledgerizer_accounts_on_tenant_type_and_tenant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledgerizer_accounts_on_tenant_type_and_tenant_id ON public.ledgerizer_accounts USING btree (tenant_type, tenant_id);


--
-- Name: index_ledgerizer_entries_on_document_type_and_document_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledgerizer_entries_on_document_type_and_document_id ON public.ledgerizer_entries USING btree (document_type, document_id);


--
-- Name: index_ledgerizer_entries_on_tenant_type_and_tenant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledgerizer_entries_on_tenant_type_and_tenant_id ON public.ledgerizer_entries USING btree (tenant_type, tenant_id);


--
-- Name: index_ledgerizer_lines_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledgerizer_lines_on_account_id ON public.ledgerizer_lines USING btree (account_id);


--
-- Name: index_ledgerizer_lines_on_accountable_type_and_accountable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledgerizer_lines_on_accountable_type_and_accountable_id ON public.ledgerizer_lines USING btree (accountable_type, accountable_id);


--
-- Name: index_ledgerizer_lines_on_document_type_and_document_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledgerizer_lines_on_document_type_and_document_id ON public.ledgerizer_lines USING btree (document_type, document_id);


--
-- Name: index_ledgerizer_lines_on_entry_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledgerizer_lines_on_entry_id ON public.ledgerizer_lines USING btree (entry_id);


--
-- Name: index_ledgerizer_lines_on_tenant_type_and_tenant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledgerizer_lines_on_tenant_type_and_tenant_id ON public.ledgerizer_lines USING btree (tenant_type, tenant_id);


--
-- Name: index_ledgerizer_revaluations_on_tenant_type_and_tenant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledgerizer_revaluations_on_tenant_type_and_tenant_id ON public.ledgerizer_revaluations USING btree (tenant_type, tenant_id);


--
-- Name: index_memberships_on_investment_asset_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_memberships_on_investment_asset_id ON public.memberships USING btree (investment_asset_id);


--
-- Name: index_memberships_on_sub_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_memberships_on_sub_account_id ON public.memberships USING btree (sub_account_id);


--
-- Name: index_money_movements_on_membership_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_money_movements_on_membership_id ON public.money_movements USING btree (membership_id);


--
-- Name: index_money_movements_on_sub_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_money_movements_on_sub_account_id ON public.money_movements USING btree (sub_account_id);


--
-- Name: index_price_change_documents_on_membership_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_price_change_documents_on_membership_id ON public.price_change_documents USING btree (membership_id);


--
-- Name: index_price_change_documents_on_price_change_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_price_change_documents_on_price_change_id ON public.price_change_documents USING btree (price_change_id);


--
-- Name: index_price_changes_on_investment_asset_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_price_changes_on_investment_asset_id ON public.price_changes USING btree (investment_asset_id);


--
-- Name: index_price_changes_on_money_movement_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_price_changes_on_money_movement_id ON public.price_changes USING btree (money_movement_id);


--
-- Name: index_relation_files_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_relation_files_on_account_id ON public.relation_files USING btree (account_id);


--
-- Name: index_relation_files_on_bank_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_relation_files_on_bank_id ON public.relation_files USING btree (bank_id);


--
-- Name: index_relation_files_on_relation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_relation_files_on_relation_id ON public.relation_files USING btree (relation_id);


--
-- Name: index_relation_files_on_sub_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_relation_files_on_sub_account_id ON public.relation_files USING btree (sub_account_id);


--
-- Name: index_relation_histories_on_relation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_relation_histories_on_relation_id ON public.relation_histories USING btree (relation_id);


--
-- Name: index_relations_on_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_relations_on_email ON public.relations USING btree (email);


--
-- Name: index_relations_on_reset_password_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_relations_on_reset_password_token ON public.relations USING btree (reset_password_token);


--
-- Name: index_relations_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_relations_on_user_id ON public.relations USING btree (user_id);


--
-- Name: index_sub_accounts_on_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_sub_accounts_on_account_id ON public.sub_accounts USING btree (account_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_wallet_deposits_on_sub_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_wallet_deposits_on_sub_account_id ON public.wallet_deposits USING btree (sub_account_id);


--
-- Name: index_wallet_withdrawals_on_sub_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_wallet_withdrawals_on_sub_account_id ON public.wallet_withdrawals USING btree (sub_account_id);


--
-- Name: unique_account_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_account_index ON public.ledgerizer_accounts USING btree (accountable_type, accountable_id, name, mirror_currency, currency, tenant_id, tenant_type);


--
-- Name: unique_entry_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_entry_index ON public.ledgerizer_entries USING btree (tenant_id, tenant_type, document_id, document_type, code, mirror_currency);


--
-- Name: unique_revaluations_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_revaluations_index ON public.ledgerizer_revaluations USING btree (tenant_id, tenant_type, revaluation_time, currency);


--
-- Name: relation_files fk_rails_0ba2ad5f03; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relation_files
    ADD CONSTRAINT fk_rails_0ba2ad5f03 FOREIGN KEY (sub_account_id) REFERENCES public.sub_accounts(id);


--
-- Name: accounts fk_rails_0ea11b1ca4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_rails_0ea11b1ca4 FOREIGN KEY (bank_id) REFERENCES public.banks(id);


--
-- Name: price_changes fk_rails_1b326a7911; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_changes
    ADD CONSTRAINT fk_rails_1b326a7911 FOREIGN KEY (investment_asset_id) REFERENCES public.investment_assets(id);


--
-- Name: accounts fk_rails_293d813fa4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_rails_293d813fa4 FOREIGN KEY (relation_id) REFERENCES public.relations(id);


--
-- Name: price_change_documents fk_rails_323a366d83; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_change_documents
    ADD CONSTRAINT fk_rails_323a366d83 FOREIGN KEY (membership_id) REFERENCES public.memberships(id);


--
-- Name: relation_files fk_rails_3f290f4d48; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relation_files
    ADD CONSTRAINT fk_rails_3f290f4d48 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: ledgerizer_lines fk_rails_3f55181982; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledgerizer_lines
    ADD CONSTRAINT fk_rails_3f55181982 FOREIGN KEY (account_id) REFERENCES public.ledgerizer_accounts(id);


--
-- Name: relation_files fk_rails_48f20c0a04; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relation_files
    ADD CONSTRAINT fk_rails_48f20c0a04 FOREIGN KEY (relation_id) REFERENCES public.relations(id);


--
-- Name: wallet_deposits fk_rails_583da62627; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_deposits
    ADD CONSTRAINT fk_rails_583da62627 FOREIGN KEY (sub_account_id) REFERENCES public.sub_accounts(id);


--
-- Name: relation_files fk_rails_72569f7162; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relation_files
    ADD CONSTRAINT fk_rails_72569f7162 FOREIGN KEY (bank_id) REFERENCES public.banks(id);


--
-- Name: memberships fk_rails_749852c244; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_rails_749852c244 FOREIGN KEY (investment_asset_id) REFERENCES public.investment_assets(id);


--
-- Name: relations fk_rails_8231c41d73; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT fk_rails_8231c41d73 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: relation_histories fk_rails_880868f6bd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relation_histories
    ADD CONSTRAINT fk_rails_880868f6bd FOREIGN KEY (relation_id) REFERENCES public.relations(id);


--
-- Name: ledgerizer_lines fk_rails_a48acef687; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledgerizer_lines
    ADD CONSTRAINT fk_rails_a48acef687 FOREIGN KEY (entry_id) REFERENCES public.ledgerizer_entries(id);


--
-- Name: price_change_documents fk_rails_ac05d991b3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_change_documents
    ADD CONSTRAINT fk_rails_ac05d991b3 FOREIGN KEY (price_change_id) REFERENCES public.price_changes(id);


--
-- Name: wallet_withdrawals fk_rails_b017eb779f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet_withdrawals
    ADD CONSTRAINT fk_rails_b017eb779f FOREIGN KEY (sub_account_id) REFERENCES public.sub_accounts(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: money_movements fk_rails_c4fcd05cb9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.money_movements
    ADD CONSTRAINT fk_rails_c4fcd05cb9 FOREIGN KEY (sub_account_id) REFERENCES public.sub_accounts(id);


--
-- Name: sub_accounts fk_rails_d560a4f53b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_accounts
    ADD CONSTRAINT fk_rails_d560a4f53b FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: memberships fk_rails_d5e9ddb20c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_rails_d5e9ddb20c FOREIGN KEY (sub_account_id) REFERENCES public.sub_accounts(id);


--
-- Name: money_movements fk_rails_fab9e44261; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.money_movements
    ADD CONSTRAINT fk_rails_fab9e44261 FOREIGN KEY (membership_id) REFERENCES public.memberships(id);


--
-- PostgreSQL database dump complete
--

