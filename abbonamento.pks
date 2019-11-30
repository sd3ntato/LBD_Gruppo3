create or replace package abbonamento as

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
  abbonamento Abbonamenti.idAbbonamento%TYPE
);

procedure aggiungiUtenti(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE
);

procedure checkUtente(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE,
  username Personel.user_name%TYPE
);

procedure aggiungiVeicoli(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE
);

procedure checkVeicolo(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE,
  v_targa Veicoli.Targa%TYPE
);

procedure checkDelegati(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2
);

procedure VeicoliCollegati(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2, 
  ruolo varchar2,
  idRiga Abbonamenti.idAbbonamento%TYPE
);


--valerio

procedure Pagamento_Inserimento_veicolo(
    id_Sessione int,
    nome varchar2,
    ruolo varchar2,
    idRiga varchar2
);

procedure Inserisci_veicolo_abbonamento(id_Sessione int, nome varchar2, ruolo varchar2, Abb Abbonamenti.idAbbonamento%type, Vei Veicoli.idVeicolo%type);

procedure Rimuovi_veicolo_abbonamento(id_Sessione int, nome varchar2, ruolo varchar2, idRiga varchar2);




end abbonamento;
