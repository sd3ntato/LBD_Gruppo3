create or replace package gruppo3 as

--abbonamenti

procedure ScegliAbbonamento(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  nomeProc varchar2
);

procedure sottoscrizioneAbbonamento(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2
);

procedure checkAbbonamento(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  abbonamento TipiAbbonamenti.idTipoAbbonamento%TYPE,
  data varchar2
);

procedure nuovoAbb(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  datai Abbonamenti.DataInizio%TYPE,
  dataf Abbonamenti.DataFine%TYPE,
  costoAbb number,
  idClienteAbb number,
  abbonamento TipiAbbonamenti.idTipoAbbonamento%TYPE,
  creditCard char
);

procedure Abbonamento_Center(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  abb Abbonamenti.idAbbonamento%TYPE
);

procedure checkUtente(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE,
  username Personel.user_name%TYPE
);

procedure checkDelegati(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2
);

procedure homeRinnovo(
    id_Sessione varchar2,
    nome varchar2,
    ruolo varchar2
);

procedure rinnovoAbbonamenti(
    id_Sessione varchar2,
    nome varchar2,
    ruolo varchar2,
    idRiga int
);

procedure updateAbb(
    id_Sessione varchar2,
    nome varchar2,
    ruolo varchar2,
    idRiga int,
    var_durata number
);

procedure IntroitiAbbonamenti(
    id_Sessione varchar2,
    nome varchar2,
    ruolo varchar2,
    mesi int default -1
);

--veicoli

procedure Pagamento_Inserimento_veicolo(
    id_Sessione int,
    nome varchar2,
    ruolo varchar2,
    idRiga varchar2
);

procedure Inserisci_veicolo_abbonamento(
    id_Sessione int,
    nome varchar2,
    ruolo varchar2,
    Abb Abbonamenti.idAbbonamento%type,
    Vei Veicoli.idVeicolo%type,
    Costo abbonamenti.CostoEffettivo%type
);

procedure Rimuovi_veicolo_abbonamento(
    id_Sessione int,
    nome varchar2,
    ruolo varchar2,
    idRiga varchar2
);

procedure VeicoliCollegati(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  idRiga Abbonamenti.idAbbonamento%TYPE
);

procedure checkVeicolo(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE,
  v_targa Veicoli.Targa%TYPE
);

procedure aggiungiVeicoli(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE
);

procedure Lista_Veicoli_Abbonamento(id_Sessione int, nome varchar2, ruolo varchar2,abb abbonamenti.idAbbonamento%type);

--utenti

procedure Rimuovi_utente_autoriz(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  idRiga varchar2
);

procedure aggiungiUtenti(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE
);


--assicurazioni

procedure VisualizzaAssicurazione(
    id_Sessione varchar2,
    nome varchar2,
    ruolo varchar2
);

procedure VisualizzaAssicurazioneAbb(
    id_Sessione varchar2,
    nome varchar2,
    ruolo varchar2,
    Abb abbonamenti.idAbbonamento%type
);

procedure richiediAssicurazione(
    id_Sessione varchar2,
    nome varchar2,
    ruolo varchar2,
    var_idAbbonamento varchar2,
    var_costomensile number
);


-- Ingressi

procedure procCronologiaAbbonamento(
    id_Sessione varchar2,
    nome varchar2,
    ruolo varchar2,
    Abb abbonamenti.idAbbonamento%type
);

--non dovremmo mostrare idAbbonamento!
procedure procCronologia(
    id_Sessione varchar2,
    nome varchar2,
    ruolo varchar2
);

  procedure Parcheggio_Abb(
      IdAbb abbonamenti.idAbbonamento%type,
      IdVei veicoli.idVeicolo%type,
      IdCli clienti.idcliente%type
  );

procedure ritiro_abbonati(Vei veicoli.idVeicolo%type);

--assegna minima area adatta a contenere il veicolo
  function Ass_area_min(
      Vei veicoli.idVeicolo%type
  )
  return aree.idArea%type;

-- Controlla la validita' dell'abbonamento dato per il cliente e per il veicolo:
-- Se l'abbonamento risulta valido ritorna l'id dell'abbonamento utilizzabile dalla coppia
-- (cliente,veicolo), motivi per cui abbonamento puo non essere valido:
--      - cliente non possiede ne puo usare alcun abbonamento
--      - veicolo non puo usare abbonamento trovato
--      - abbonamento scaduto
--      - orario attuale fuori fascia oraria di validita abbonamento
  function ContrAbb ( id_Cli in clienti.idCliente%type, id_Vei in veicoli.idVeicolo%type )
  return abbonamenti.idabbonamento%type;


--tipiAbbonamenti

procedure dettagliTipiAbb(id_Sessione varchar2, nome varchar2, ruolo varchar2, idRiga varchar2);

procedure visualizzaTipiAbb(id_Sessione varchar2, nome varchar2, ruolo varchar2, idRiga varchar2 default 0);

procedure modificaTipiAbb(id_Sessione varchar2, nome varchar2, ruolo varchar2, idRiga varchar2);

procedure modificaTipiAbbDati(id_Sessione varchar2, nome varchar2, ruolo varchar2, var_idTipoAbbonamento varchar2, var_maxveicoli number,
var_maxclienti number, var_maxautorimesse number, var_durata number, var_costo number, var_tipoabbonamento varchar2, var_orainizio number, var_orafine number);

procedure inserisciTipiAbb(id_Sessione varchar2, nome varchar2, ruolo varchar2);

procedure inserisciTipiAbbDati(id_Sessione varchar2, nome varchar2, ruolo varchar2, var_maxveicoli number, var_maxclienti number, var_maxautorimesse number, var_durata number, var_costo number, var_tipoabbonamento varchar2, var_orainizio number, var_orafine number);


end gruppo3;
