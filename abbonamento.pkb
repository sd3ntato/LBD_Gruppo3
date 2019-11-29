create or replace package body abbonamento as
  
procedure sottoscrizioneAbbonamento(
  id_Sessione Sessioni.idSessione%TYPE, 
  nome varchar2, 
  ruolo varchar2
) 
is  
begin
 modGUI.apriPagina('HoC | Sottoscrizione Abbonamento', id_Sessione, nome, ruolo);

	modGUI.aCapo;
	modGUI.apriIntestazione(3);
		modGUI.inserisciTesto('SOTTOSCRIZIONE ABBONAMENTO');
	modGUI.chiudiIntestazione(3);
  modGUI.apriDiv;
  modGui.apriForm('abbonamento.checkAbbonamento');
    modGui.inserisciinputHidden('id_Sessione', id_Sessione);
    modGui.inserisciinputHidden('nome', nome);
    modGui.inserisciinputHidden('ruolo', ruolo);
      modGUI.inserisciTesto('Tipo Abbonamento: ');
      modGUI.aCapo;
      modGUI.apriSelect('Abbonamento', 'abbonamento');
      for tipoabbonamenti in (select idTipoAbbonamento from tipiabbonamenti)    
      loop                
      modGUI.inserisciOpzioneSelect(tipoabbonamenti.idtipoabbonamento, tipoabbonamenti.idtipoabbonamento, false);
      end loop;
      modGUI.chiudiSelect;
      modGUI.aCapo;
      modGUI.inserisciTesto('Data Inizio: ');
      modGUI.inserisciInput('data', 'date', 'Data', true);
      modGUI.aCapo;

      modGUI.inserisciBottoneReset('RESET');
      modGUI.inserisciBottoneForm('CONTINUA');
  modGui.chiudiForm;

  modGUI.chiudiDiv;
 modGUI.chiudiPagina;

end sottoscrizioneAbbonamento;

procedure checkAbbonamento(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2, 
  ruolo varchar2,
  abbonamento TipiAbbonamenti.idTipoAbbonamento%TYPE, 
  data varchar2
) 
is
  datai Abbonamenti.DataInizio%TYPE;
  dataf Abbonamenti.DataFine%TYPE;
  durataAbb tipiabbonamenti.durata%TYPE;
  costoAbb tipiabbonamenti.durata%TYPE;
  creditCard Clienti.CartaDiCredito%TYPE;
  idClienteAbb Clienti.idCliente%TYPE;
  currentdata date;
begin
  datai:=to_date(data, 'yyyy/mm/dd', 'NLS_DATE_LANGUAGE = ITALIAN');

  currentdata:=to_date(CURRENT_DATE, 'yyyy/mm/dd');
  
  if datai >= currentdata
    then
      select durata, costo 
      into durataAbb, costoAbb
      from tipiabbonamenti
      where abbonamento = idtipoabbonamento;
          
      dataf:=datai+durataAbb;

      select Clienti.idCliente, CartaDiCredito
      into idClienteAbb, creditCard
      from sessioni, persone, clienti 
      where id_Sessione = sessioni.idSessione and
            sessioni.idPersona = persone.idPersona and
            persone.idPersona = clienti.idPersona;

      modGUI.apriPagina('HoC | Pagamento', id_Sessione, nome, ruolo);

        modGUI.aCapo;
        modGUI.apriIntestazione(3);
          modGUI.inserisciTesto('RIEPILOGO PAGAMENTO');
        modGUI.chiudiIntestazione(3);
        modGUI.apriDiv;
          modGui.apritabella;
          modgui.apririgatabella;

          modgui.intestazionetabella('Data Inizio');
          modgui.intestazionetabella('Data Fine');
          modgui.intestazionetabella('Costo Abbonamento');
          modgui.intestazionetabella('Carta di Credito utilizzata');
          modGui.chiudirigatabella;

          modgui.apririgatabella;
          modGUI.aprielementotabella;
          modGUI.elementotabella(datai);
          modGUI.chiudielementotabella;
          modGUI.aprielementotabella;
          modGUI.elementotabella(dataf);
          modGUI.chiudielementotabella;
          modGUI.aprielementotabella;
          modGUI.elementotabella(costoAbb||' €');
          modGUI.chiudielementotabella;
          modGUI.aprielementotabella;
          modGUI.elementotabella(creditCard);
          modGUI.chiudielementotabella;

          modGUI.chiudirigatabella;
          modGUI.chiuditabella;
        modGUI.chiudiDiv;
        modGui.apriForm('abbonamento.nuovoAbb');
            modGui.inserisciinputHidden('id_Sessione', id_Sessione);
            modGui.inserisciinputHidden('nome', nome);
            modGui.inserisciinputHidden('ruolo', ruolo);
            modGui.inserisciinputHidden('datai', datai);
            modGui.inserisciinputHidden('dataf', dataf);
            modGui.inserisciinputHidden('costoAbb', costoAbb);
            modGui.inserisciinputHidden('idClienteAbb', idClienteAbb);
            modGui.inserisciinputHidden('abbonamento', abbonamento);
            modGui.inserisciinputHidden('creditCard', creditCard);
            modGUI.inserisciBottoneForm('EFFETTUA PAGAMENTO');
          modGUI.chiudiForm;
      modGUI.chiudiPagina;
    else
      modGUI.apriPagina('HoC | Errore Data', id_Sessione, nome, ruolo);
      modGui.esitoOperazione('KO', 'Data inserita minore della data attuale');
      modGUI.chiudiPagina;
  end if;
end checkAbbonamento;


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
) 
is
begin
  INSERT INTO Abbonamenti (idAbbonamento, DataInizio, DataFine, CostoEffettivo, idCliente, idTipoAbbonamento)
  VALUES (AbbonamentiSeq.nextval, datai, dataf, costoAbb, idClienteAbb ,abbonamento);

  modGUI.apriPagina('HoC | AbbonamentoCreato', id_Sessione, nome, ruolo);
    modGui.esitoOperazione('OK', 'Abbonamento Creato');
    modGui.apriForm('abbonamento.Abbonamento_Center');
            modGui.inserisciinputHidden('id_Sessione', id_Sessione);
            modGui.inserisciinputHidden('nome', nome);
            modGui.inserisciinputHidden('ruolo', ruolo);
            modGui.inserisciinputHidden('abbonamento', AbbonamentiSeq.currval);
            modGUI.inserisciBottoneForm('RIEPILOGO ABBONAMENTO');
          modGUI.chiudiForm;
  modGUI.chiudiPagina;
end nuovoAbb;

procedure Abbonamento_Center(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2, 
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE
) 
is  
  idClienteAbb Clienti.idCliente%TYPE;
  v_count integer;
  cursor c_veicoli_prop is (
      select produttore, modello, colore, targa , veicoli.idVeicolo
      from VeicoliClienti join Veicoli on VeicoliClienti.idVeicolo=veicoli.idVeicolo
      where veicoliClienti.idCliente= idClienteAbb);
  r_veicolo c_veicoli_prop%RowType;
  v_maxveicoli TipiAbbonamenti.maxveicoli%TYPE;
  v_maxclienti TipiAbbonamenti.maxveicoli%TYPE;
  c int:=0;
  v_TipoAbbonamento TipiAbbonamenti.idTipoAbbonamento%TYPE;
  datai Abbonamenti.DataInizio%TYPE;
  dataf Abbonamenti.DataFine%TYPE;
  costoAbb Abbonamenti.CostoEffettivo%TYPE; 
  creditCard Clienti.CartaDiCredito%TYPE;
begin
  select Abbonamenti.idTipoAbbonamento, Abbonamenti.DataInizio, Abbonamenti.DataFine, Abbonamenti.CostoEffettivo, Clienti.CartaDiCredito, Abbonamenti.idCliente
    into v_TipoAbbonamento, datai, dataf, costoAbb, creditCard, idClienteAbb
    from Abbonamenti 
        join Clienti on Abbonamenti.idCliente = Clienti.idCliente
   where idabbonamento = abbonamento;

  select maxveicoli, maxclienti
      into v_maxveicoli, v_maxclienti
      from tipiabbonamenti
      where v_TipoAbbonamento = idtipoabbonamento;
  
  modGUI.apriPagina('HoC | Pagamento', id_Sessione, nome, ruolo);

    modGUI.aCapo;
    modGUI.apriIntestazione(3);
      modGUI.inserisciTesto('RIEPILOGO ABBONAMENTO');
    modGUI.chiudiIntestazione(3);
      modGui.apritabella;

      modgui.apririgatabella;
        modgui.intestazionetabella('Data Inizio');
        modGUI.aprielementotabella;
        modGUI.elementotabella(datai);
        modGUI.chiudielementotabella;
      modGui.chiudirigatabella;
      modgui.apririgatabella;
        modgui.intestazionetabella('Data Fine');
        modGUI.aprielementotabella;
        modGUI.elementotabella(dataf);
        modGUI.chiudielementotabella;
      modGui.chiudirigatabella;        
      modgui.apririgatabella;
        modgui.intestazionetabella('Costo Abbonamento');
        modGUI.aprielementotabella;
        modGUI.elementotabella(costoAbb||' €');
        modGUI.chiudielementotabella;
      modGui.chiudirigatabella;   
      modgui.apririgatabella;     
        modgui.intestazionetabella('Carta di Credito utilizzata');
        modGUI.aprielementotabella;
        modGUI.elementotabella(creditCard);
        modGUI.chiudielementotabella;
      modGui.chiudirigatabella;   
    modGUI.chiuditabella;

    modGui.apritabella;
      modgui.apririgatabella;
        modgui.intestazionetabella('Utenti usufruenti');
      modGui.chiudirigatabella;

      for clienti in (
        select user_name
        from Abbonamenti, AbbonamentiClienti, Clienti, personel
        where abbonamento = Abbonamenti.idAbbonamento and
              Abbonamenti.idAbbonamento = AbbonamentiClienti.idAbbonamento and
              AbbonamentiClienti.idCliente = clienti.idCliente and 
              clienti.idPersona = personel.idPersona)    
      loop                
        modgui.apririgatabella;
          modGUI.aprielementotabella;
            modGUI.elementotabella(clienti.user_name);
          modGUI.chiudielementotabella;
        modGUI.chiudirigatabella;
        c:=c+1;
      end loop;
    if c=0
      then
        modgui.apririgatabella;
          modGUI.aprielementotabella;
            modGUI.elementotabella('Nessun Utente collegato');
          modGUI.chiudielementotabella;
        modGUI.chiudirigatabella;
    end if;
    modGUI.chiuditabella;

    modGUI.apriForm('abbonamento.aggiungiUtenti');
      modGui.inserisciinputHidden('id_Sessione', id_Sessione);
      modGui.inserisciinputHidden('nome', nome);
      modGui.inserisciinputHidden('ruolo', ruolo);
      modGui.inserisciinputHidden('abbonamento', abbonamento);
      modGUI.inserisciBottoneForm('AGGIUNGI UTENTE');
    modGUI.chiudiForm;

      c:=0;
        modGUI.aCapo;
        modGUI.apriIntestazione(1);
            modGUI.inserisciTesto('Lista Veicoli');
        modGUI.chiudiIntestazione(1);
        modGUI.apriDiv;
          open c_veicoli_prop;
          fetch c_veicoli_prop into r_veicolo;
          if c_veicoli_prop%Found then 
              modgui.apritabella;
              modgui.intestazionetabella('produttore');
              modgui.intestazionetabella('modello');
              modgui.intestazionetabella('targa');
              modgui.intestazionetabella('inserisci');
              modgui.intestazionetabella('rimuovi');            
              loop
                modgui.apririgatabella;
                modGUI.apriElementoTabella;
                    modgui.inseriscitesto(r_veicolo.produttore);
                modgui.chiudielementotabella;
                modGUI.apriElementoTabella;
                    modgui.inseriscitesto(r_veicolo.modello);
                modgui.chiudielementotabella;
                modGUI.apriElementoTabella;
                    modgui.inseriscitesto(r_veicolo.targa);
                modgui.chiudielementotabella;
                select count(*) into v_count from AbbonamentiVeicoli where idAbbonamento=abbonamento and idVeicolo=r_veicolo.idVeicolo;
                    if v_count = 0 then
                        modGUI.apriElementoTabella;
                        modGui.inserisciPenna('Inserisci_veicolo_abbonamento', id_Sessione, nome, ruolo, r_veicolo.idVeicolo||' '||abbonamento );
                        modgui.chiudiElementotabella;
                        modGUI.apriElementoTabella;
                        modgui.inserisciTesto('non presente');
                        modgui.chiudiElementotabella;
                    else
                        modGUI.apriElementoTabella;
                        modGui.InserisciTesto('presente');
                        modgui.chiudiElementotabella;
                        modGUI.apriElementoTabella;
                        modGui.inserisciPenna('Rimuovi_veicolo_abbonamento', id_Sessione, nome, ruolo, r_veicolo.idVeicolo||' '||abbonamento);
                        modgui.chiudiElementotabella;                    
                    end if;
                modgui.chiudielementotabella;
                modgui.chiudirigatabella;   
              fetch c_veicoli_prop into r_veicolo;
              exit when c_veicoli_prop%NotFound;
              c:=c+1;
              end loop;
          else 
             modGUI.apriIntestazione(3);
                 modGUI.inserisciTesto('Lista Veicoli proprietario vuota');
             modGUI.chiudiIntestazione(3);
          end if;
    if c=0
      then
        modgui.apririgatabella;
          modGUI.aprielementotabella;
            modGUI.elementotabella('Nessun Veicolo collegato');
          modGUI.chiudielementotabella;
        modGUI.chiudirigatabella;
    end if;
    modGUI.chiuditabella;
  modGUI.chiudiPagina;
end Abbonamento_Center;

procedure aggiungiUtenti(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2, 
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE
) 
is
begin
  modGUI.apriPagina('HoC | Aggiungi Utenti', id_Sessione, nome, ruolo);
    modGUI.aCapo;
    modGUI.apriIntestazione(3);
      modGUI.inserisciTesto('AGGIUNGI UTENTE AL TUO ABBONAMENTO');
    modGUI.chiudiIntestazione(3);
    modGUI.apriDiv;
      modGui.apriForm('abbonamento.checkUtente');
        modGui.inserisciinputHidden('id_Sessione', id_Sessione);
        modGui.inserisciinputHidden('nome', nome);
        modGui.inserisciinputHidden('ruolo', ruolo);
        modGui.inserisciinputHidden('abbonamento', abbonamento);
        modGUI.inserisciInput('Username utente', 'text', 'username', true, classe=>'myInputLogin');
        modGUI.aCapo;
        modGUI.inserisciBottoneForm('CONTINUA');
      modGUI.chiudiForm;
    modGUI.chiudiDiv;
  modGUI.chiudiPagina;
end aggiungiUtenti;

procedure checkUtente(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2, 
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE, 
  username Personel.user_name%TYPE
) 
is
  idClienteAss Clienti.idCliente%TYPE;  
  i int;
begin

  select idCliente
    into idClienteAss
    from Clienti, personel
   where username = personel.user_name and
          personel.idPersona = Clienti.idPersona;

  select count(*)
    into i
    from AbbonamentiClienti
   where abbonamento = idAbbonamento and
          idClienteAss = idCliente;
  

  if i=0 
    then 
      INSERT INTO AbbonamentiClienti (idAbbonamento, idCliente)
      VALUES (abbonamento, idClienteAss);
      Abbonamento_Center(id_Sessione, nome, ruolo, abbonamento);
    else
      modGUI.apriPagina('HoC | Utente già collegato', id_Sessione, nome, ruolo);
        modGui.esitoOperazione('KO', 'Utente già collegato');
        modGui.apriForm('abbonamento.Abbonamento_Center');
                modGui.inserisciinputHidden('id_Sessione', id_Sessione);
                modGui.inserisciinputHidden('nome', nome);
                modGui.inserisciinputHidden('ruolo', ruolo);
                modGui.inserisciinputHidden('abbonamento', abbonamento);
                modGUI.inserisciBottoneForm('RIEPILOGO ABBONAMENTO');
        modGUI.chiudiForm;
        modGui.apriForm('abbonamento.aggiungiUtenti');
                modGui.inserisciinputHidden('id_Sessione', id_Sessione);
                modGui.inserisciinputHidden('nome', nome);
                modGui.inserisciinputHidden('ruolo', ruolo);
                modGui.inserisciinputHidden('abbonamento', abbonamento);
                modGUI.inserisciBottoneForm('AGGIUNGI UTENTI');
              modGUI.chiudiForm;
      modGUI.chiudiPagina;
  end if;
Exception
  when no_data_found then
    modGUI.apriPagina('HoC | Utente non presente', id_Sessione, nome, ruolo);
    modGui.esitoOperazione('KO', 'Utente non presente');
    modGui.apriForm('abbonamento.Abbonamento_Center');
            modGui.inserisciinputHidden('id_Sessione', id_Sessione);
            modGui.inserisciinputHidden('nome', nome);
            modGui.inserisciinputHidden('ruolo', ruolo);
            modGui.inserisciinputHidden('abbonamento', abbonamento);
            modGUI.inserisciBottoneForm('RIEPILOGO ABBONAMENTO');
    modGUI.chiudiForm;
    modGui.apriForm('abbonamento.aggiungiUtenti');
            modGui.inserisciinputHidden('id_Sessione', id_Sessione);
            modGui.inserisciinputHidden('nome', nome);
            modGui.inserisciinputHidden('ruolo', ruolo);
            modGui.inserisciinputHidden('abbonamento', abbonamento);
            modGUI.inserisciBottoneForm('AGGIUNGI UTENTI');
          modGUI.chiudiForm;
  modGUI.chiudiPagina;
end checkUtente;

procedure aggiungiVeicoli(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2, 
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE
) 
is
  
begin
  modGUI.apriPagina('HoC | Aggiungi Veicoli', id_Sessione, nome, ruolo);
    modGUI.aCapo;
    modGUI.apriIntestazione(3);
      modGUI.inserisciTesto('AGGIUNGI VEICOLI AL TUO ABBONAMENTO');
    modGUI.chiudiIntestazione(3);
    modGUI.apriDiv;
      modGui.apriForm('abbonamento.checkVeicolo');
        modGui.inserisciinputHidden('id_Sessione', id_Sessione);
        modGui.inserisciinputHidden('nome', nome);
        modGui.inserisciinputHidden('ruolo', ruolo);
        modGui.inserisciinputHidden('abbonamento', abbonamento);
        modGUI.inserisciInput('Targa Veicolo', 'text', 'v_targa', true, classe=>'myInputLogin');
        modGUI.aCapo;
        modGUI.inserisciBottoneForm('CONTINUA');
      modGUI.chiudiForm;
    modGUI.chiudiDiv;
  modGUI.chiudiPagina;
end aggiungiVeicoli;

procedure checkVeicolo(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2, 
  ruolo varchar2,
  abbonamento Abbonamenti.idAbbonamento%TYPE,
  v_targa Veicoli.Targa%TYPE
) 
is
  idVeicoloAss Veicoli.idVeicolo%TYPE;
  idClienteAbb Clienti.idCliente%TYPE;
  i int;
begin
  select idCliente
    into idClienteAbb
    from Abbonamenti
   where idAbbonamento = abbonamento;

  select Veicoli.idVeicolo
    into idVeicoloAss
    from Veicoli, VeicoliClienti
   where v_targa = Veicoli.targa and
          Veicoli.idVeicolo = VeicoliClienti.idVeicolo and
          VeicoliClienti.idCliente = idClienteAbb;

  select count(*)
    into i
    from AbbonamentiVeicoli
   where abbonamento = idAbbonamento and
          idVeicoloAss = idVeicolo;

  if i=0
    then 
      INSERT INTO AbbonamentiVeicoli (idAbbonamento, idVeicolo)
      VALUES (abbonamento, idVeicoloAss);
      Abbonamento_Center(id_Sessione, nome, ruolo, abbonamento);
    else
      modGUI.apriPagina('HoC | Veicolo già collegato', id_Sessione, nome, ruolo);
        modGui.esitoOperazione('KO', 'Veicolo già collegato');
        modGui.apriForm('abbonamento.Abbonamento_Center');
                modGui.inserisciinputHidden('id_Sessione', id_Sessione);
                modGui.inserisciinputHidden('nome', nome);
                modGui.inserisciinputHidden('ruolo', ruolo);
                modGui.inserisciinputHidden('abbonamento', abbonamento);
                modGUI.inserisciBottoneForm('RIEPILOGO ABBONAMENTO');
        modGUI.chiudiForm;
        modGui.apriForm('abbonamento.aggiungiVeicoli');
                modGui.inserisciinputHidden('id_Sessione', id_Sessione);
                modGui.inserisciinputHidden('nome', nome);
                modGui.inserisciinputHidden('ruolo', ruolo);
                modGui.inserisciinputHidden('abbonamento', abbonamento);
                modGUI.inserisciBottoneForm('AGGIUNGI VEICOLO');
              modGUI.chiudiForm;
      modGUI.chiudiPagina;
  end if;
  
Exception
  when no_data_found then
    modGUI.apriPagina('HoC | Veicolo non presente', id_Sessione, nome, ruolo);
    modGui.esitoOperazione('KO', 'Veicolo non presente');
    modGui.apriForm('abbonamento.Abbonamento_Center');
            modGui.inserisciinputHidden('id_Sessione', id_Sessione);
            modGui.inserisciinputHidden('nome', nome);
            modGui.inserisciinputHidden('ruolo', ruolo);
            modGui.inserisciinputHidden('abbonamento', abbonamento);
            modGUI.inserisciBottoneForm('RIEPILOGO ABBONAMENTO');
    modGUI.chiudiForm;
    modGui.apriForm('abbonamento.aggiungiVeicoli');
            modGui.inserisciinputHidden('id_Sessione', id_Sessione);
            modGui.inserisciinputHidden('nome', nome);
            modGui.inserisciinputHidden('ruolo', ruolo);
            modGui.inserisciinputHidden('abbonamento', abbonamento);
            modGUI.inserisciBottoneForm('AGGIUNGI VEICOLO');
          modGUI.chiudiForm;
  modGUI.chiudiPagina;
end checkVeicolo;

end abbonamento;