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
--sdsd
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
    --variabile e cursore per veicoli utenti autorizzati
    cursor c_veicoli_aut is (
    select produttore, modello, colore, targa , veicoli.idVeicolo, Persone.nome as nomev, Persone.cognome as cognomev
            from VeicoliClienti join Veicoli on VeicoliClienti.idVeicolo=veicoli.idVeicolo
            join Clienti on Clienti.idCliente=VeicoliClienti.idCliente
            join Persone on Persone.idPersona=Clienti.idPersona
            where veicoliClienti.idCliente in ( select Clienti.idCliente
                from AbbonamentiClienti join clienti on AbbonamentiClienti.idcliente=Clienti.idCliente
                where AbbonamentiClienti.idAbbonamento=abbonamento
                )
                --and VeicoliClienti.idCliente != v_cli
                and VeicoliClienti.idVeicolo not in (select VeicoliClienti.idVeicolo
                    from VeicoliClienti
                    where VeicoliClienti.idCliente = idClienteAbb)
    );
    r_veicoli_aut c_veicoli_aut%RowType;


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
        select user_name, Clienti.idCliente
        from Abbonamenti, AbbonamentiClienti, Clienti, personel
        where abbonamento = Abbonamenti.idAbbonamento and
              Abbonamenti.idAbbonamento = AbbonamentiClienti.idAbbonamento and
              AbbonamentiClienti.idCliente = clienti.idCliente and
              clienti.idPersona = personel.idPersona)
      loop
        modgui.apririgatabella;
          modGUI.aprielementotabella;
            modGUI.elementotabella(clienti.user_name);
            modGUI.inserisciCestino('abbonamento.Rimuovi_utente_autoriz', id_Sessione, nome, ruolo, clienti.idCliente||' '||abbonamento);
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
      select count(*) into c
        from AbbonamentiVeicoli
        where AbbonamentiVeicoli.idAbbonamento = abbonamento;
        modGUI.aCapo;
        modGUI.apriIntestazione(1);
            modGUI.inserisciTesto(' Lista Veicoli: ');
        modGUI.chiudiIntestazione(1);
        if c=v_maxveicoli
          then
            modGUI.apriIntestazione(3);
            modGUI.inserisciTesto(' raggiunto limite massimo veicoli ');
            modGui.chiudiIntestazione(3);
        end if;
        modGUI.apriDiv;
        --veicoli proprietario
          open c_veicoli_prop;
          fetch c_veicoli_prop into r_veicolo;
          if c_veicoli_prop%Found then
              modgui.apritabella;
              modgui.intestazionetabella('Produttore');
              modgui.intestazionetabella('Modello');
              modgui.intestazionetabella('Targa');
              if c< v_maxveicoli then
                modgui.intestazionetabella('Inserisci');
              end if;
              modgui.intestazionetabella('Rimuovi');
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
                        if c< v_maxveicoli then
                          modGUI.apriElementoTabella;
                          modGui.inserisciPenna('abbonamento.Pagamento_Inserimento_veicolo', id_Sessione, nome, ruolo, r_veicolo.idVeicolo||' '||abbonamento );
                          modgui.chiudiElementotabella;
                        end if;
                        modGUI.apriElementoTabella;
                        modgui.inserisciTesto('non presente');
                        modgui.chiudiElementotabella;
                    else
                        if c< v_maxveicoli then
                            modGUI.apriElementoTabella;
                            modGui.InserisciTesto('presente');
                            modgui.chiudiElementotabella;
                        end if;
                        modGUI.apriElementoTabella;
                        modGui.inserisciPenna('abbonamento.Rimuovi_veicolo_abbonamento', id_Sessione, nome, ruolo, r_veicolo.idVeicolo||' '||abbonamento);
                        modgui.chiudiElementotabella;
                    end if;
                modgui.chiudielementotabella;
                modgui.chiudirigatabella;
              fetch c_veicoli_prop into r_veicolo;
              exit when c_veicoli_prop%NotFound;
              --c:=c+1;
              end loop;
          else
             modGUI.apriIntestazione(3);
                 modGUI.inserisciTesto('Lista Veicoli proprietario vuota');
             modGUI.chiudiIntestazione(3);
          end if;

          -- veicoli utenti collegati
          modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('veicoli utenti autorizzati: ');
          modGui.chiudiIntestazione(2);
          open c_veicoli_aut;
          fetch c_veicoli_aut into r_veicoli_aut;
          if c_veicoli_aut%Found then
            modGUI.apriDiv;
            modgui.apritabella;
            modgui.intestazionetabella('produttore');
            modgui.intestazionetabella('modello');
            modgui.intestazionetabella('targa');
            modgui.intestazionetabella('proprietario');
            if c< v_maxveicoli then
                modgui.intestazionetabella('inserisci');
            end if;
            modgui.intestazionetabella('rimuovi');
            loop
                modgui.apririgatabella;
                modGUI.apriElementoTabella;
                    modgui.inseriscitesto(r_veicoli_aut.produttore);
                modgui.chiudielementotabella;
                modGUI.apriElementoTabella;
                    modgui.inseriscitesto(r_veicoli_aut.modello);
                modgui.chiudielementotabella;
                modGUI.apriElementoTabella;
                    modgui.inseriscitesto(r_veicoli_aut.targa);
                modgui.chiudielementotabella;
                modGUI.apriElementoTabella;
                    modgui.inseriscitesto(r_veicoli_aut.nomev||' '||r_veicoli_aut.cognomev);
                modgui.chiudielementotabella;
                select count(*) into v_count from AbbonamentiVeicoli where idAbbonamento=abbonamento and idVeicolo=r_veicoli_aut.idVeicolo;
                    if v_count = 0 then
                        if c< v_maxveicoli then
                            modGUI.apriElementoTabella;
                            modGui.inserisciPenna('abbonamento.Pagamento_Inserimento_veicolo', id_Sessione, nome, ruolo, r_veicoli_aut.idVeicolo||' '||abbonamento );
                            modgui.chiudiElementotabella;
                        end if;
                        modGUI.apriElementoTabella;
                        modgui.inserisciTesto('non presente');
                        modgui.chiudiElementotabella;
                    else
                        if c< v_maxveicoli then
                            modGUI.apriElementoTabella;
                            modGui.InserisciTesto('presente');
                            modgui.chiudiElementotabella;
                        end if;
                        modGUI.apriElementoTabella;
                        modGui.inserisciPenna('abbonamento.Rimuovi_veicolo_abbonamento', id_Sessione, nome, ruolo, r_veicoli_aut.idVeicolo||' '||abbonamento);
                        modgui.chiudiElementotabella;
                    end if;
                modgui.chiudielementotabella;
                modgui.chiudirigatabella;
                fetch c_veicoli_aut into r_veicoli_aut;
                exit when c_veicoli_aut%notFound;
             end loop;
             modGui.chiudiTabella;
             modGuI.chiudiDiv;
            else
             modGUI.apriIntestazione(3);
                 modGUI.inserisciTesto('Lista Veicoli utenti autorizzati vuota');
             modGUI.chiudiIntestazione(3);
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
  idClienteAbb Clienti.idCliente%TYPE;
  i int;
begin

  select idCliente
    into idClienteAss
    from Clienti, personel
   where username = personel.user_name and
          personel.idPersona = Clienti.idPersona;

  select Clienti.idCliente
    into idClienteAbb
    from Sessioni
        join Clienti on Sessioni.idPersona = Clienti.idPersona
   where Sessioni.idSessione = id_Sessione;

  if idClienteAbb=idClienteAss
    then
      modGUI.apriPagina('HoC | Errore', id_Sessione, nome, ruolo);
      modGui.esitoOperazione('KO', 'Sei già il proprietario');
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
    else
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


procedure checkDelegati(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2
)
is
  cursor c_abb_ass is (
    select abbonamenti.idAbbonamento, persone.nome, persone.cognome, TipiAbbonamenti.TipoAbbonamento, Abbonamenti.DataFine
    from Abbonamenti join Clienti on Abbonamenti.idCliente = Clienti.idCliente
    join Persone on Persone.idPersona =Clienti.idPersona
    join TipiAbbonamenti on Abbonamenti.idTipoAbbonamento =tipiAbbonamenti.idTipoAbbonamento
    where abbonamenti.idAbbonamento in (
        select AbbonamentiClienti.idAbbonamento
        from AbbonamentiClienti
            join Clienti on AbbonamentiClienti.idCliente = Clienti.idCliente
            join Sessioni on Clienti.idPersona = Sessioni.idPersona
        where Sessioni.idSessione =id_Sessione)
        );
  r_abb c_abb_ass%RowType;
  currentdata date;
  scadenza number;
  dataf Abbonamenti.DataFine%TYPE;
begin
  modGUI.apriPagina('HoC | Veicolo non presente', id_Sessione, nome, ruolo);
     modGUI.aCapo;
      modGUI.apriIntestazione(1);
          modGUI.inserisciTesto('Lista Abbonamenti associati');
      modGUI.chiudiIntestazione(1);
      modGUI.apriDiv;
        open c_abb_ass;
        fetch c_abb_ass into r_abb;
        if c_abb_ass%Found then
          modgui.apritabella;
          modgui.intestazionetabella('Cognome Possessore');
          modgui.intestazionetabella('Nome Possessore');
          modgui.intestazionetabella('Tipo abbonamento');
          modgui.intestazionetabella('Tempo Rimanente');
          modgui.intestazionetabella('Veicoli Collegati');
          loop
            currentdata:=to_date(CURRENT_DATE, 'dd-Mon-yy');
            dataf:=r_abb.DataFine;
            select dataf - currentdata
              into scadenza
              from dual;
            if scadenza>0
              then
              modgui.apririgatabella;
                modGUI.apriElementoTabella;
                    modgui.inseriscitesto(r_abb.Cognome);
                modgui.chiudielementotabella;
                modGUI.apriElementoTabella;
                    modgui.inseriscitesto(r_abb.Nome);
                modgui.chiudielementotabella;
                modGUI.apriElementoTabella;
                    modgui.inseriscitesto(r_abb.TipoAbbonamento);
                modgui.chiudielementotabella;
                modGUI.apriElementoTabella;
                  modgui.inseriscitesto(scadenza || ' giorni');
                modgui.chiudielementotabella;
                modGUI.apriElementoTabella;
                    modgui.inserisciLente('abbonamento.VeicoliCollegati', id_Sessione, nome, ruolo, r_abb.idAbbonamento);
                modgui.chiudielementotabella;
              modgui.chiudirigatabella;
            end if;
            fetch c_abb_ass into r_abb;
            exit when c_abb_ass%NotFound;
          end loop;
          modGUI.chiuditabella;
        else
          modGUI.apriIntestazione(3);
              modGUI.inserisciTesto('Non sei collegato a nessun Abbonamento');
          modGUI.chiudiIntestazione(3);
        end if;
      modGUI.chiudiDiv;
  modGUI.chiudiPagina;
end checkDelegati;

procedure VeicoliCollegati(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  idRiga Abbonamenti.idAbbonamento%TYPE
)
is
  cursor c_veicoli_prop is (
    select produttore, modello, targa, veicoli.idVeicolo
    from Abbonamenti
        join AbbonamentiVeicoli on Abbonamenti.idabbonamento = AbbonamentiVeicoli.idabbonamento
        join Veicoli on AbbonamentiVeicoli.idVeicolo = Veicoli.idVeicolo
    where Abbonamenti.idAbbonamento = idRiga);
  r_veicolo c_veicoli_prop%RowType;
begin
  modGUI.apriPagina('HoC | Veicoli Collegati', id_Sessione, nome, ruolo);
  modGUI.aCapo;
  modGUI.apriIntestazione(3);
    modGUI.inserisciTesto('VEICOLI COLLEGATI');
  modGUI.chiudiIntestazione(3);
  modGUI.apriDiv;
    open c_veicoli_prop;
    fetch c_veicoli_prop into r_veicolo;
    if c_veicoli_prop%Found then
      modgui.apritabella;
      modgui.intestazionetabella('Produttore');
      modgui.intestazionetabella('Modello');
      modgui.intestazionetabella('Targa');
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
        modgui.chiudirigatabella;
        fetch c_veicoli_prop into r_veicolo;
        exit when c_veicoli_prop%NotFound;
      end loop;
      modGUI.chiuditabella;
    else
        modGUI.apriIntestazione(3);
            modGUI.inserisciTesto('Lista Veicoli proprietario vuota');
        modGUI.chiudiIntestazione(3);
  end if;
  modGUI.chiudiPagina;
end VeicoliCollegati;

procedure Pagamento_Inserimento_veicolo(id_Sessione int, nome varchar2, ruolo varchar2, idRiga varchar2)
as
    Veicolo number(38,0);
    Abbonamento number(38,0);
    str1 varchar2(200); str2 varchar2(200);
    v_count integer;
    v_max TipiAbbonamenti.MaxVeicoli%type;
    v_area Aree.idArea%type;
    v_costo TipiAbbonamenti.Costo%type;
    max_veicoli_raggiunto exception;
    pragma exception_init (max_veicoli_raggiunto,-2001);
    Area_non_trovata exception;

begin
    SELECT (REGEXP_SUBSTR (idRiga, '(\S+)')) into str1  FROM dual ;
    SELECT REGEXP_SUBSTR (idRiga, '(\S+)',1,2) into str2 FROM dual ;
    Veicolo := to_number(str1);
    Abbonamento := to_number(str2);
    v_area:= marianiv.Ass_area_min(Veicolo);
    if v_area = null then raise Area_non_trovata; end if;
    select Aree.CostoAbbonamento into v_costo
        from Aree
            where Aree.idArea =v_area;
    modGUI.apriPagina('HoC | Pagamento', id_Sessione, nome, ruolo);
    select count(*) into v_count
        from AbbonamentiVeicoli
        where idAbbonamento= Abbonamento and idVeicolo= Veicolo;
    if v_count != 0 then
        modgui.esitoOperazione('ko','veicolo gia presente');
    else
        select tipiAbbonamenti.MaxVeicoli
            into v_max
            from TipiAbbonamenti join Abbonamenti on Abbonamenti.idTipoAbbonamento = TipiAbbonamenti.idTipoAbbonamento
            where abbonamenti.idAbbonamento = Abbonamento;
        select count(*)
            into v_count
            from AbbonamentiVeicoli
        where AbbonamentiVeicoli.idAbbonamento = Abbonamento;
        if v_count<= v_max then
            modgui.apriform(azione=>'abbonamento.Inserisci_Veicolo_abbonamento');
            modGUI.ApriIntestazione(3);
                modGUI.inserisciTesto('prezzo da pagare per inserire veicolo: '||v_costo);
            modGUI.ChiudiIntestazione(3);
            modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
            modGUI.inserisciInputHidden('nome',nome);
            modGUI.inserisciInputHidden('ruolo',ruolo);
            modGUI.inserisciInputHidden('Abb',Abbonamento);
            modGUI.inserisciInputHidden('Vei',Veicolo);
            modGUI.inserisciInputHidden('Costo',v_costo);
            modgui.inseriscibottoneform(testo=>'paga');
            modgui.chiudiform;
        else
            modGUI.esitoOperazione('ko','maxVeicoliRaggiunto');
        end if;
    end if;
    modGui.aCapo;
            modgui.apriform(azione=>'abbonamento.Abbonamento_Center');
            modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
            modGUI.inserisciInputHidden('nome',nome);
            modGUI.inserisciInputHidden('ruolo',ruolo);
            modGUI.inserisciInputHidden('abbonamento',Abbonamento);
            modgui.inseriscibottoneform(testo=>'indietro');
            modgui.chiudiform;
    exception
        when Area_non_trovata then modGUI.esitoOperazione('ko','il tuo veicolo non puo essere contenuto in nessuna area');
end;

procedure Inserisci_veicolo_abbonamento(id_Sessione int, nome varchar2, ruolo varchar2, Abb Abbonamenti.idAbbonamento%type, Vei Veicoli.idVeicolo%type, Costo abbonamenti.CostoEffettivo%type)
as
    str1 varchar2(200); str2 varchar2(200);
    v_count integer;
    v_ok varchar(20);
    max_veicoli_raggiunto exception;
    pragma exception_init (max_veicoli_raggiunto,-2001);

begin
/*
    SELECT (REGEXP_SUBSTR (idRiga, '(\S+)')) into str1  FROM dual ;
    SELECT REGEXP_SUBSTR (idRiga, '(\S+)',1,2) into str2 FROM dual ;
    Veicolo := to_number(str1);
    Abbonamento := to_number(str2);
*/
    modGUI.apriPagina('HoC | Esito manipolazione veicoli abbonamento', id_Sessione, nome, ruolo);
    select count(*) into v_count
        from AbbonamentiVeicoli
        where idAbbonamento= Abb and idVeicolo= Vei;
    if v_count != 0 then
        --v_ok:='nok';
        modgui.esitoOperazione('ko','veicolo gia presente');
    else
        insert into AbbonamentiVeicoli values ( Abb, Vei);
        update abbonamenti set CostoEffettivo=CostoEffettivo+Costo where idAbbonamento=Abb;
        --v_ok:='ok'
        modgui.esitoOperazione('ok','operazione effettuata');
    end if;
    modGUI.apriDiv(centrato=>true);
        modgui.inseriscibottone(id_Sessione,nome,ruolo,'home','modgui.creaHome','defFormButton');
    modGUI.chiudiDiv;
        modgui.apriform(azione=>'abbonamento.Abbonamento_Center');
    modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
    modGUI.inserisciInputHidden('nome',nome);
    modGUI.inserisciInputHidden('ruolo',ruolo);
    modGUI.inserisciInputHidden('abbonamento',Abb);
    modgui.inseriscibottoneform(testo=>'riepilogo abbonamento');
    modgui.chiudiform;


    --modgui.inseriscibottone(id_Sessione,nome,ruolo,'ancora','abbonamento.Abbonamento_Center','defFormButton');
    --marianiv.Lista_Veicoli_abbonamento(id_Sessione,nome,ruolo,v_ok);
exception
    when max_veicoli_raggiunto then modgui.esitoOperazione('ko','troppi veicoli');
    modgui.inseriscibottone(id_Sessione,nome,ruolo,'home','modgui.creaHome','defFormButton');
    modgui.inseriscibottone(id_Sessione,nome,ruolo,'ancora','abbonamento.Abbonamento_Center','defFormButton');
end;

procedure Rimuovi_veicolo_abbonamento(id_Sessione int, nome varchar2, ruolo varchar2, idRiga varchar2)
as
    Veicolo number(38,0);
    Abbonamento number(38,0);
    str1 varchar2(200); str2 varchar2(200);
    cursor cVei(Abb number ,Vei number ) is
        select AbbonamentiVeicoli.idAbbonamento
        from AbbonamentiVeicoli
        where idAbbonamento= Abb and idVeicolo= Vei;
    v_ok varchar2(10);
    v_costo Abbonamenti.CostoEffettivo%type;
begin
    SELECT (REGEXP_SUBSTR (idRiga, '(\S+)')) into str1  FROM dual ;
    SELECT REGEXP_SUBSTR (idRiga, '(\S+)',1,2) into str2 FROM dual ;
    Veicolo := to_number(str1);
    Abbonamento := to_number(str2);
    select Aree.costoAbbonamento into v_costo from Aree where idArea= (marianiv.Ass_area_min(veicolo));
    modGUI.apriPagina('HoC | Esito manipolazione veicoli abbonamento', id_Sessione, nome, ruolo);
    open cVei(Abbonamento,Veicolo) ;
    fetch cVei into Abbonamento;
    if sql%NotFound then modgui.esitoOperazione('ko','veicolo non presente');
    else
        delete from AbbonamentiVeicoli where idVeicolo= Veicolo and idAbbonamento=Abbonamento ;
        update abbonamenti set CostoEffettivo=CostoEffettivo-v_costo where idAbbonamento=Abbonamento;
        modgui.esitoOperazione('ok','veicolo eliminato');
    end if;
    --marianiv.Lista_Veicoli_abbonamento(id_Sessione,nome,ruolo,v_ok);
    modGUI.apriDiv(centrato=>true);
        modgui.inseriscibottone(id_Sessione,nome,ruolo,'home','modgui.creaHome','defFormButton');
    modGUI.chiudiDiv;
        modgui.apriform(azione=>'abbonamento.Abbonamento_Center');
    modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
    modGUI.inserisciInputHidden('nome',nome);
    modGUI.inserisciInputHidden('ruolo',ruolo);
    modGUI.inserisciInputHidden('abbonamento',Abbonamento);
    modgui.inseriscibottoneform(testo=>'riepilogo abbonamento');
    modgui.chiudiform;
end;

procedure ScegliAbbonamento( id_Sessione Sessioni.idSessione%TYPE, nome varchar2, ruolo varchar2)
is
    v_idCliente Clienti.idCliente%type;
    cursor c_abbs (cliente Clienti.idCliente%type) is (
     select abbonamenti.idAbbonamento, abbonamenti.DATAFINE, TipiAbbonamenti.TipoAbbonamento
      from abbonamenti join Clienti on Abbonamenti.idCliente= Clienti.idCliente
      join TipiAbbonamenti on abbonamenti.idTipoAbbonamento= tipiAbbonamenti.idTipoAbbonamento
      where Clienti.idCliente =cliente
    );
    r_abbonamento c_abbs%Rowtype;
begin
    modGUI.apriPagina('HoC | scleta abbonamento utilizzato', id_Sessione, nome, ruolo);

    select Clienti.idCliente
      into v_idCliente
      from sessioni, persone, clienti
      where id_Sessione = sessioni.idSessione and
            sessioni.idPersona = persone.idPersona and
            persone.idPersona = clienti.idPersona;

    open c_abbs (v_idCliente);
    fetch c_abbs into r_abbonamento;
    if c_abbs%NotFound then modGUI.esitoOperazione('ko','a quanto pare non possiedi alcun abbonamento');
    else
        modGui.ApriForm('abbonamento.Abbonamento_center');
        modGui.inserisciinputHidden('id_Sessione', id_Sessione);
        modGui.inserisciinputHidden('nome', nome);
        modGui.inserisciinputHidden('ruolo', ruolo);
        modGUI.apriSelect('abbonamento', 'scelta abbonamento');
        loop
            modGui.inserisciOpzioneSelect(r_abbonamento.idAbbonamento,'ABBONAMENTO '|| r_abbonamento.TipoAbbonamento|| ' IN SCADENZA '||r_abbonamento.DATAFINE);
            fetch c_abbs into r_abbonamento;
            exit when c_abbs%NotFound;
        end loop;
        modGui.chiudiSelect;
        modGui.inserisciBottoneForm('scegli');
        modGUI.chiudiForm;
    end if;
    /**/

end ScegliAbbonamento;

procedure Rimuovi_utente_autoriz( id_Sessione Sessioni.idSessione%TYPE, nome varchar2, ruolo varchar2,idRiga varchar2)
is
    str1 varchar2(30);
    str2 varchar2(30);
    v_utente Clienti.idCliente%type;
    v_abbonamento Abbonamenti.idAbbonamento%type;
begin
    modGui.apriPagina('HoC | scleta abbonamento utilizzato', id_Sessione, nome, ruolo);
    SELECT (REGEXP_SUBSTR (idRiga, '(\S+)')) into str1  FROM dual ;
    SELECT REGEXP_SUBSTR (idRiga, '(\S+)',1,2) into str2 FROM dual ;
    v_utente:= to_number(str1);
    v_abbonamento := to_number(str2);
    delete from AbbonamentiClienti where idCliente=v_utente and idAbbonamento=v_abbonamento;
    if sql%Found then
        modGui.esitoOperazione('ok','utente rimosso');
    else
        modGUI.esitoOperazione('ko','impossibile rimuovere utente: utente non presente');
    end if;
        modGUI.apriDiv(centrato=>true);
        modgui.inseriscibottone(id_Sessione,nome,ruolo,'home','modgui.creaHome','defFormButton');
    modGUI.chiudiDiv;
        modgui.apriform(azione=>'abbonamento.Abbonamento_Center');
    modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
    modGUI.inserisciInputHidden('nome',nome);
    modGUI.inserisciInputHidden('ruolo',ruolo);
    modGUI.inserisciInputHidden('abbonamento',v_abbonamento);
    modgui.inseriscibottoneform(testo=>'riepilogo abbonamento');
    modgui.chiudiform;
end Rimuovi_utente_autoriz;


end abbonamento;
