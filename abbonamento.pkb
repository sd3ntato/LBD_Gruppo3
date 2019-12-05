create or replace package body gruppo3 as


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
  modGui.apriForm('gruppo3.checkAbbonamento');
    modGui.inserisciinputHidden('id_Sessione', id_Sessione);
    modGui.inserisciinputHidden('nome', nome);
    modGui.inserisciinputHidden('ruolo', ruolo);
      modGUI.inserisciTesto('Tipo Abbonamento: ');
      modGUI.aCapo;
      modGUI.apriSelect('Abbonamento', 'abbonamento');
      for tipoabbonamenti in (select idTipoAbbonamento, TipoAbbonamento from tipiabbonamenti)
      loop
      modGUI.inserisciOpzioneSelect(tipoabbonamenti.idtipoabbonamento, tipoabbonamenti.tipoabbonamento, false);
      end loop;
      modGUI.chiudiSelect;
      modGUI.aCapo;
      modGUI.inserisciTesto('Data Inizio: ');
      modGUI.inserisciInput('data', 'date', 'Date', true);
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
        --apriDiv(centrato=>true);
        --modGUI.inserisciBottone(id_sessione, nome, ruolo, 'Aggiungi Utenti' ,'gruppo3.aggiungiUtenti', '&datai='||datai||'&datai='||datai||'&datai='||datai||'&datai='||datai||);
        modGUI.chiudiDiv;
        modGui.apriForm('gruppo3.nuovoAbb');
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
  INSERT INTO Abbonamenti (idAbbonamento, DataInizio, DataFine, CostoEffettivo, idCliente, idTipoAbbonamento, PagamentiAbbonamenti)
  VALUES (AbbonamentiSeq.nextval, datai, dataf, costoAbb, idClienteAbb ,abbonamento, costoAbb);

  modGUI.apriPagina('HoC | AbbonamentoCreato', id_Sessione, nome, ruolo);
    modGui.esitoOperazione('OK', 'Abbonamento Creato');
    modGui.apriForm('gruppo3.Abbonamento_Center');
            modGui.inserisciinputHidden('id_Sessione', id_Sessione);
            modGui.inserisciinputHidden('nome', nome);
            modGui.inserisciinputHidden('ruolo', ruolo);
            modGui.inserisciinputHidden('abb', AbbonamentiSeq.currval);
            modGUI.inserisciBottoneForm('RIEPILOGO ABBONAMENTO');
          modGUI.chiudiForm;
  modGUI.chiudiPagina;
end nuovoAbb;









procedure Abbonamento_Center(
  id_Sessione Sessioni.idSessione%TYPE,
  nome varchar2,
  ruolo varchar2,
  abb Abbonamenti.idAbbonamento%TYPE
)
is

  v_maxveicoli TipiAbbonamenti.maxveicoli%TYPE;
  v_maxclienti TipiAbbonamenti.maxveicoli%TYPE;
  idClienteAbb Clienti.idCliente%TYPE; --proprietario
  v_TipoAbbonamento TipiAbbonamenti.idTipoAbbonamento%TYPE;
  datai Abbonamenti.DataInizio%TYPE;
  dataf Abbonamenti.DataFine%TYPE;
  costoAbb Abbonamenti.CostoEffettivo%TYPE;
  creditCard Clienti.CartaDiCredito%TYPE;
  TipoAbb tipiAbbonamenti.TipoAbbonamento%type;
  c int:=0;
  v_count int:=0;

------------------------------------ cursore e contenitore per assicurazione ------------------------------
  cursor c_ass(abb abbonamenti.idAbbonamento%type) is (
        select assicurazioni.idAssicurazione
        from Assicurazioni
        where assicurazioni.idAbbonamento=abb
    );
  v_ass assicurazioni.idAbbonamento%type;
------------------------------------------------------------------------------------------------------------

-------------------------------cursore e contenitore per veicoli del proprietario---------------------------
  cursor c_veicoli_prop is (
      select produttore, modello, colore, targa , veicoli.idVeicolo
      from VeicoliClienti join Veicoli on VeicoliClienti.idVeicolo=veicoli.idVeicolo
      where veicoliClienti.idCliente= idClienteAbb
      );
  r_veicolo c_veicoli_prop%RowType;
------------------------------------------------------------------------------------------------------------

-------------------------------cursore e contenitore per veicoli utenti autorizzati---------------------------
    cursor c_veicoli_aut is (
    select produttore, modello, colore, targa , veicoli.idVeicolo, Persone.nome as nomev, Persone.cognome as cognomev
            from VeicoliClienti join Veicoli on VeicoliClienti.idVeicolo=veicoli.idVeicolo
            join Clienti on Clienti.idCliente=VeicoliClienti.idCliente
            join Persone on Persone.idPersona=Clienti.idPersona
            where veicoliClienti.idCliente in ( select Clienti.idCliente
                from AbbonamentiClienti join clienti on AbbonamentiClienti.idcliente=Clienti.idCliente
                where AbbonamentiClienti.idAbbonamento=abb
                )
                --and VeicoliClienti.idCliente != v_cli
                and VeicoliClienti.idVeicolo not in (select VeicoliClienti.idVeicolo
                    from VeicoliClienti
                    where VeicoliClienti.idCliente = idClienteAbb)
    );
    r_veicoli_aut c_veicoli_aut%RowType;
------------------------------------------------------------------------------------------------------------

-------------------------------cursore e contenitore utenti autorizzati ad uso-------------------------------
    CURSOR cursor_clienti IS (
    select abbonamenticlienti.idcliente, persone.nome, persone.cognome, persone.telefono, clienti.NumeroPatente
        from Abbonamenti, AbbonamentiClienti, Clienti, personel, persone
        where abb = Abbonamenti.idAbbonamento and
              Abbonamenti.idAbbonamento = AbbonamentiClienti.idAbbonamento and
              persone.idPersona=clienti.idPersona and
              AbbonamentiClienti.idCliente = clienti.idCliente and
              clienti.idPersona = personel.idPersona and
              clienti.Cancellato = 'F'
    );

    infoClienti cursor_clienti%ROWTYPE;
------------------------------------------------------------------------------------------------------------


begin
  select Abbonamenti.idTipoAbbonamento, Abbonamenti.DataInizio, Abbonamenti.DataFine, Abbonamenti.CostoEffettivo, Clienti.CartaDiCredito, Abbonamenti.idCliente, tipiAbbonamenti.TipoAbbonamento
    into v_TipoAbbonamento, datai, dataf, costoAbb, creditCard, idClienteAbb, TipoAbb
    from Abbonamenti join TipiAbbonamenti on Abbonamenti.idTipoAbbonamento = tipiAbbonamenti.idTipoAbbonamento
        join Clienti on Abbonamenti.idCliente = Clienti.idCliente
   where idabbonamento = abb;

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
      modgui.apririgatabella;
        modgui.intestazionetabella('Tipo Abbonamento');
        modGUI.aprielementotabella;
        modGUI.elementotabella(TipoAbb);
        modGUI.chiudielementotabella;
      modGui.chiudirigatabella;
      modgui.apririgatabella;
        modgui.intestazionetabella('Assicurazione');
        modGUI.aprielementotabella;
        open c_ass (abb); fetch c_ass into v_ass;
        if c_ass%Found then
            modGUI.collegamento('Dettagli', 'gruppo3.VisualizzaAssicurazioneAbb?id_Sessione='||id_Sessione||'&nome='||nome||'&ruolo='||ruolo||'&Abb='||abb);
        else
            modGUI.collegamento('Richiedi Assicurazione', 'gruppo3.VisualizzaAssicurazioneAbb?id_Sessione='||id_Sessione||'&nome='||nome||'&ruolo='||ruolo||'&Abb='||abb);
        end if;
        modGUI.chiudielementotabella;
      modGui.chiudirigatabella;
      modGui.apriRigaTabella;
        modgui.intestazionetabella('Cronologia degli accessi');
        modGui.apriElementoTabella;
        modGui.collegamento('Visualizza','gruppo3.procCronologiaAbbonamento?id_Sessione='||id_Sessione||'&nome='||nome||'&ruolo='||ruolo||'&Abb='||abb);
        modGui.chiudiElementoTabella;
      modGui.chiudiRigaTabella;
    modGUI.chiuditabella;


      modGUI.apriIntestazione(2);
        modgui.inseriscitesto('Utenti usufruenti:');
      modGUI.chiudiIntestazione(2);
      v_count:=0;
      open cursor_clienti;
      fetch cursor_clienti into infoClienti;
      if cursor_clienti%Found then
        MODGUI.apriTabella;
            MODGUI.apriRigaTabella;
                MODGUI.intestazioneTabella('NOME');
                MODGUI.intestazioneTabella('COGNOME');
                MODGUI.intestazioneTabella('TELEFONO');
                MODGUI.intestazioneTabella('PATENTE');
                MODGUI.intestazioneTabella('ELIMINA');
            MODGUI.chiudiRigaTabella;
          loop
             v_count:=v_count+1;
             MODGUI.ApriRigaTabella;
                MODGUI.ApriElementoTabella;
                    MODGUI.ElementoTabella(infoClienti.nome);
                MODGUI.ChiudiElementoTabella;
                MODGUI.ApriElementoTabella;
                    MODGUI.ElementoTabella(infoClienti.cognome);
                MODGUI.ChiudiElementoTabella;
                MODGUI.ApriElementoTabella;
                    MODGUI.ElementoTabella(infoClienti.telefono);
                MODGUI.ChiudiElementoTabella;
                MODGUI.ApriElementoTabella;
                    MODGUI.ElementoTabella(infoClienti.numeropatente);
                MODGUI.ChiudiElementoTabella;
                MODGUI.ApriElementoTabella;
                    MODGUI.inserisciCestino('gruppo3.Rimuovi_utente_autoriz', id_Sessione, nome, ruolo, infoClienti.idcliente||' '||abb);
                MODGUI.ChiudiElementoTabella;
            MODGUI.ChiudiRigaTabella;
            fetch cursor_clienti into infoClienti;
            exit when cursor_clienti%NotFound;
          end loop;
        modGUI.chiudiTabella;
        else
          modGUI.apriIntestazione(2);
            modgui.inseriscitesto('Nessun Utente collegato');
          modGUI.chiudiIntestazione(2);
        end if;
    select tipiAbbonamenti.MaxClienti into c from abbonamenti join Tipiabbonamenti on abbonamenti.idTipoAbbonamento=tipiAbbonamenti.idTipoAbbonamento
    where abbonamenti.idAbbonamento = abb;
    if c>v_count then -- c: tipitabbonamenti.maxVeicoli v_count: utenti collegati
        --se troppi utenti collegati non permetto inserimento
        --procedure inserisciBottone(id_Sessione varchar2, nome varchar2, ruolo varchar2, testo , nomeProc , parametri , classe varchar2 );
        modGUI.apriDiv(centrato=>true);
            modGUI.inserisciBottone(id_sessione, nome, ruolo, 'Aggiungi Utenti' ,'gruppo3.aggiungiUtenti', '&abbonamento='||abb);
        modGui.chiudiDiv;
    else
      modGUI.apriIntestazione(3);
        modgui.inseriscitesto('limite massimo utenti collegati raggiunto: per inserire altri utenti rimuoverne almeno uno dalla lista');
      modGUI.chiudiIntestazione(3);
    end if;
      c:=0;
    modGUI.apriDiv;
        modGUI.apriIntestazione(1);
            modGUI.inserisciTesto(' Lista Veicoli: ');
        modGUI.chiudiIntestazione(1);
    modGUI.chiudiDiv;
    select count(*) into c --controllo se e' possibile aggiungere veicoli
    from AbbonamentiVeicoli
    where AbbonamentiVeicoli.idAbbonamento = abb;
    modGUI.aCapo;
        --veicoli proprietario
    modGUI.apriDiv;
        modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('veicoli del proprietario: ');
        modGui.chiudiIntestazione(2);
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
                select count(*) into v_count from AbbonamentiVeicoli where idAbbonamento=abb and idVeicolo=r_veicolo.idVeicolo;
                    if v_count = 0 then
                        if c< v_maxveicoli then
                          modGUI.apriElementoTabella;
                          modGui.inserisciPenna('gruppo3.Pagamento_Inserimento_veicolo', id_Sessione, nome, ruolo, r_veicolo.idVeicolo||' '||abb );
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
                        modGui.inserisciCestino('gruppo3.Rimuovi_veicolo_abbonamento', id_Sessione, nome, ruolo, r_veicolo.idVeicolo||' '||abb);
                        modgui.chiudiElementotabella;
                    end if;
                modgui.chiudielementotabella;
                modgui.chiudirigatabella;
              fetch c_veicoli_prop into r_veicolo;
              exit when c_veicoli_prop%NotFound;
              --c:=c+1;
              end loop;
              modGui.chiudiTabella;
          else
             modGUI.apriIntestazione(3);
                 modGUI.inserisciTesto('Lista Veicoli proprietario vuota');
             modGUI.chiudiIntestazione(3);
          end if;
          modgui.chiudidiv;

          -- veicoli utenti collegati
          modGUI.apriDiv;
          modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('veicoli utenti autorizzati: ');
          modGui.chiudiIntestazione(2);
          open c_veicoli_aut;
          fetch c_veicoli_aut into r_veicoli_aut;
          if c_veicoli_aut%Found then
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
                select count(*) into v_count from AbbonamentiVeicoli where idAbbonamento=abb and idVeicolo=r_veicoli_aut.idVeicolo;
                    if v_count = 0 then
                        if c< v_maxveicoli then
                            modGUI.apriElementoTabella;
                            modGui.inserisciPenna('gruppo3.Pagamento_Inserimento_veicolo', id_Sessione, nome, ruolo, r_veicoli_aut.idVeicolo||' '||abb );
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
                        modGui.inserisciPenna('gruppo3.Rimuovi_veicolo_abbonamento', id_Sessione, nome, ruolo, r_veicoli_aut.idVeicolo||' '||abb);
                        modgui.chiudiElementotabella;
                    end if;
                modgui.chiudielementotabella;
                modgui.chiudirigatabella;
                fetch c_veicoli_aut into r_veicoli_aut;
                exit when c_veicoli_aut%notFound;
             end loop;
             modGui.chiudiTabella;
            else
             modGUI.apriIntestazione(3);
                 modGUI.inserisciTesto('Lista Veicoli utenti autorizzati vuota');
             modGUI.chiudiIntestazione(3);
            end if;
            if c=v_maxveicoli
              then
                modGUI.apriIntestazione(3);
                modGUI.inserisciTesto(' raggiunto limite massimo veicoli, per inserire altri veicoli rimuovere prima almeno un veicolo gia presente ');
                modGui.chiudiIntestazione(3);
            end if;
            modGUI.chiudiDiv;
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
      modGui.apriForm('gruppo3.checkUtente');
        modGui.inserisciinputHidden('id_Sessione', id_Sessione);
        modGui.inserisciinputHidden('nome', nome);
        modGui.inserisciinputHidden('ruolo', ruolo);
        modGui.inserisciinputHidden('abbonamento', abbonamento);
        modGUI.inserisciInput('Username', 'text', 'username', true, classe=>'myInputLogin');
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
      modGui.apriForm('gruppo3.Abbonamento_Center');
              modGui.inserisciinputHidden('id_Sessione', id_Sessione);
              modGui.inserisciinputHidden('nome', nome);
              modGui.inserisciinputHidden('ruolo', ruolo);
              modGui.inserisciinputHidden('abbonamento', abbonamento);
              modGUI.inserisciBottoneForm('RIEPILOGO ABBONAMENTO');
      modGUI.chiudiForm;
      modGui.apriForm('gruppo3.aggiungiUtenti');
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
            modGui.apriForm('gruppo3.Abbonamento_Center');
                    modGui.inserisciinputHidden('id_Sessione', id_Sessione);
                    modGui.inserisciinputHidden('nome', nome);
                    modGui.inserisciinputHidden('ruolo', ruolo);
                    modGui.inserisciinputHidden('abbonamento', abbonamento);
                    modGUI.inserisciBottoneForm('RIEPILOGO ABBONAMENTO');
            modGUI.chiudiForm;
            modGui.apriForm('gruppo3.aggiungiUtenti');
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
    modGui.apriForm('gruppo3.Abbonamento_Center');
            modGui.inserisciinputHidden('id_Sessione', id_Sessione);
            modGui.inserisciinputHidden('nome', nome);
            modGui.inserisciinputHidden('ruolo', ruolo);
            modGui.inserisciinputHidden('abbonamento', abbonamento);
            modGUI.inserisciBottoneForm('RIEPILOGO ABBONAMENTO');
    modGUI.chiudiForm;
    modGui.apriForm('gruppo3.aggiungiUtenti');
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
      modGui.apriForm('gruppo3.checkVeicolo');
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
        modGui.apriForm('gruppo3.Abbonamento_Center');
                modGui.inserisciinputHidden('id_Sessione', id_Sessione);
                modGui.inserisciinputHidden('nome', nome);
                modGui.inserisciinputHidden('ruolo', ruolo);
                modGui.inserisciinputHidden('abbonamento', abbonamento);
                modGUI.inserisciBottoneForm('RIEPILOGO ABBONAMENTO');
        modGUI.chiudiForm;
        modGui.apriForm('gruppo3.aggiungiVeicoli');
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
    modGui.apriForm('gruppo3.Abbonamento_Center');
            modGui.inserisciinputHidden('id_Sessione', id_Sessione);
            modGui.inserisciinputHidden('nome', nome);
            modGui.inserisciinputHidden('ruolo', ruolo);
            modGui.inserisciinputHidden('abbonamento', abbonamento);
            modGUI.inserisciBottoneForm('RIEPILOGO ABBONAMENTO');
    modGUI.chiudiForm;
    modGui.apriForm('gruppo3.aggiungiVeicoli');
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
                    modgui.inserisciLente('gruppo3.VeicoliCollegati', id_Sessione, nome, ruolo, r_abb.idAbbonamento);
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
    v_area:= gruppo3.Ass_area_min(Veicolo);
    if v_area = null then raise Area_non_trovata; end if;
    modGUI.apriPagina('HoC | Pagamento', id_Sessione, nome, ruolo);


    select Aree.CostoAbbonamento into v_costo
        from Aree
            where Aree.idArea =v_area;

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
            modgui.apriform(azione=>'gruppo3.Inserisci_Veicolo_abbonamento');
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
    /**/
    modGui.aCapo;
            modgui.apriform(azione=>'gruppo3.Abbonamento_Center');
            modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
            modGUI.inserisciInputHidden('nome',nome);
            modGUI.inserisciInputHidden('ruolo',ruolo);
            modGUI.inserisciInputHidden('abbonamento',Abbonamento);
            modgui.inseriscibottoneform(testo=>'indietro');
            modgui.chiudiform;
    exception
        when Area_non_trovata then modGUI.esitoOperazione('KO','il tuo veicolo non puo essere contenuto in nessuna area');
        when max_veicoli_raggiunto then modGUI.esitoOperazione('KO','troppi veicoli');
        when no_data_found then modGUI.esitoOperazione('KO','no data found');
end;







procedure Inserisci_veicolo_abbonamento(id_Sessione int, nome varchar2, ruolo varchar2, Abb Abbonamenti.idAbbonamento%type, Vei Veicoli.idVeicolo%type, Costo abbonamenti.CostoEffettivo%type)
as
    str1 varchar2(200); str2 varchar2(200);
    v_count integer;
    v_ok varchar(20);
    max_veicoli_raggiunto exception;
    pragma exception_init (max_veicoli_raggiunto,-2001);

begin

    modGUI.apriPagina('HoC | Esito manipolazione veicoli abbonamento', id_Sessione, nome, ruolo);
    select count(*) into v_count
        from AbbonamentiVeicoli
        where idAbbonamento= Abb and idVeicolo= Vei;

    if v_count != 0 then
        --v_ok:='nok';
        modgui.esitoOperazione('KO','veicolo gia presente');
    else

        insert into AbbonamentiVeicoli (idAbbonamento, idVeicolo) values ( Abb, Vei);

        update abbonamenti set CostoEffettivo=CostoEffettivo+Costo
                        ,PagamentiAbbonamenti=PagamentiAbbonamenti+Costo
        where idAbbonamento=Abb;

        --v_ok:='ok'
        modgui.esitoOperazione('ok','operazione effettuata');
    end if;

    modGUI.apriDiv(centrato=>true);
        modgui.inseriscibottone(id_Sessione,nome,ruolo,'home','modgui.creaHome','defFormButton');
    modGUI.chiudiDiv;
        modgui.apriform(azione=>'gruppo3.Abbonamento_Center');
    modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
    modGUI.inserisciInputHidden('nome',nome);
    modGUI.inserisciInputHidden('ruolo',ruolo);
    modGUI.inserisciInputHidden('abb',Abb);
    modgui.inseriscibottoneform(testo=>'riepilogo abbonamento');
    modgui.chiudiform;


    --modgui.inseriscibottone(id_Sessione,nome,ruolo,'ancora','gruppo3.Abbonamento_Center','defFormButton');
    --marianiv.Lista_Veicoli_abbonamento(id_Sessione,nome,ruolo,v_ok);
exception
    when max_veicoli_raggiunto then modgui.esitoOperazione('KO','troppi veicoli');
    modgui.inseriscibottone(id_Sessione,nome,ruolo,'home','modgui.creaHome','defFormButton');
    modgui.inseriscibottone(id_Sessione,nome,ruolo,'ancora','gruppo3.Abbonamento_Center','defFormButton');
    when no_data_found then modgui.esitoOperazione('KO','no data found');
    modgui.inseriscibottone(id_Sessione,nome,ruolo,'home','modgui.creaHome','defFormButton');
    modgui.inseriscibottone(id_Sessione,nome,ruolo,'ancora','gruppo3.Abbonamento_Center','defFormButton','&abb='||Abb);
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
    select Aree.costoAbbonamento into v_costo from Aree where idArea= (gruppo3.Ass_area_min(veicolo));
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
        modgui.apriform(azione=>'gruppo3.Abbonamento_Center');
    modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
    modGUI.inserisciInputHidden('nome',nome);
    modGUI.inserisciInputHidden('ruolo',ruolo);
    modGUI.inserisciInputHidden('abb',Abbonamento);
    modgui.inseriscibottoneform(testo=>'riepilogo abbonamento');
    modgui.chiudiform;

    exception
        when no_data_found then modGui.esitoOperazione('KO','no data found');
end;






procedure ScegliAbbonamento( id_Sessione Sessioni.idSessione%TYPE, nome varchar2, ruolo varchar2, nomeProc varchar2)
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
        modGui.ApriForm('gruppo3.'||nomeProc);
        modGui.inserisciinputHidden('id_Sessione', id_Sessione);
        modGui.inserisciinputHidden('nome', nome);
        modGui.inserisciinputHidden('ruolo', ruolo);
        modGUI.apriSelect('Abb', 'scelta abbonamento');
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
        modgui.apriform(azione=>'gruppo3.Abbonamento_Center');
    modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
    modGUI.inserisciInputHidden('nome',nome);
    modGUI.inserisciInputHidden('ruolo',ruolo);
    modGUI.inserisciInputHidden('abb',v_abbonamento);
    modgui.inseriscibottoneform(testo=>'riepilogo abbonamento');
    modgui.chiudiform;

end Rimuovi_utente_autoriz;






--assicurazioni




procedure VisualizzaAssicurazione(id_Sessione varchar2, nome varchar2, ruolo varchar2) --dovremmo passare idAbb
is
  v_abb abbonamenti.idAbbonamento%type;
  v_abb_t tipiabbonamenti.tipoabbonamento%type;
  v_abb_i abbonamenti.datainizio%type;
  v_abb_f abbonamenti.datafine%type;
  cursor c_abb is
    select abbonamenti.idAbbonamento , tipiabbonamenti.tipoabbonamento, abbonamenti.datainizio, abbonamenti.datafine
      from sessioni join clienti on sessioni.idPersona=clienti.idPersona
      join abbonamenti on clienti.idCliente=abbonamenti.idCliente
	  join tipiabbonamenti on abbonamenti.idTipoAbbonamento = tipiabbonamenti.idTipoAbbonamento
      where sessioni.idSessione=id_Sessione;

  v_ass assicurazioni.idAssicurazione%type;
  v_desc assicurazioni.descrizione%type;
  v_costo assicurazioni.costomensile%type;
  cursor c_ass (Abb_ref abbonamenti.idAbbonamento%type ) is
    select assicurazioni.idAssicurazione,assicurazioni.descrizione,assicurazioni.costomensile
      from abbonamenti join assicurazioni on abbonamenti.idAbbonamento = assicurazioni.idAbbonamento
      where abbonamenti.idAbbonamento=Abb_ref;

    Abbonamento_non_trovato exception;

  begin
	if(ruolo = 'C') then
    open c_abb;
    fetch c_abb into v_abb, v_abb_t, v_abb_i ,v_abb_f;
    if c_abb%NotFound then raise Abbonamento_non_trovato; end if;
    --v_abb contiene riferimento ad abbonamento oppure sono crashato
    modGUI.apriPagina('HoC | Visualizza Assicurazione', id_Sessione , nome, ruolo);
    modGUI.aCapo;
    modGUI.apriIntestazione(2);
        modGUI.inserisciTesto('VISUALIZZA ASSICURAZIONE PER ABBONAMENTO');
    modGUI.chiudiIntestazione(2);
    while c_abb%Found loop
        open c_ass(v_abb);
        fetch c_ass into v_ass,v_desc,v_costo ;
			modGUI.apriIntestazione(3);
                modgui.inserisciTesto('Abbonamento '||v_abb_t||' (valido da '||v_abb_i||' a '|| v_abb_f ||')');
			modGUI.chiudiIntestazione(3);
        if c_ass%NotFound then
                modGUI.apriForm('gruppo3.richiediAssicurazione');
					modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
					modGUI.inserisciInputHidden('nome',nome);
					modGUI.inserisciInputHidden('ruolo',ruolo);
					modGUI.inserisciInputHidden('var_idAbbonamento',v_abb);
					modGUI.inserisciTesto('Non hai nessuna assicurazione attiva, richiedine una adesso.');
					modGUI.aCapo;
					modGUI.aCapo;
					modGUI.apriSelect(nome=>'var_costomensile',etichetta=>'Tipo Assicurazione',richiesto=>true);
					modGUI.inserisciOpzioneSelect(valore=>'20',etichetta=>'BASE',selezionato=>true);
					modGUI.inserisciOpzioneSelect(valore=>'35',etichetta=>'PREMIUM');
					modGUI.inserisciOpzioneSelect(valore=>'50',etichetta=>'SUPER PREMIUM');
					modGUI.chiudiSelect;
					modGUI.inserisciBottoneForm('Richiedi Assicurazione');

                modGUI.chiudiForm;

        else
            --v_ass contiene riferimento ad assicurazione oppure sono crashato
				modGUI.apriTabella;
                modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('Descrizione');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(v_desc);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;

                modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('Costo mensile');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(v_costo);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
				modGUI.chiudiTabella;
        end if;
        close c_ass;
    fetch c_abb into v_abb, v_abb_t, v_abb_i ,v_abb_f;
    end loop;
	modGUI.chiudiPagina;

	else
		modGUI.apriPagina('Errore', id_Sessione, nome, ruolo);
		modGUI.esitoOperazione('KO', 'Non hai permessi per effettuare questa operazione');
		modGUI.apriDiv(centrato=>true);
			modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'visualizzaTipiAbb', 'defFormButton');
		modGUI.chiudiDiv;
	modGUI.chiudiPagina;
	end if;
  exception
    when Abbonamento_non_trovato then
        begin
            modGUI.apriPagina('HoC | Visualizza Assicurazione', id_Sessione , nome, ruolo);
            modGUI.aCapo;
            modGUI.aCapo;
            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('VISUALIZZA ASSICURAZIONE PER ABBONAMENTO');
        	modGUI.chiudiIntestazione(2);
			modGUI.aCapo;
			modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('Non � presente alcun abbonamento attivo.');
        	modGUI.chiudiIntestazione(3);
        end;
end VisualizzaAssicurazione ;





procedure VisualizzaAssicurazioneAbb(id_Sessione varchar2, nome varchar2, ruolo varchar2, Abb abbonamenti.idAbbonamento%type)
is
  v_abb abbonamenti.idAbbonamento%type;
  v_abb_t tipiabbonamenti.tipoabbonamento%type;
  v_abb_i abbonamenti.datainizio%type;
  v_abb_f abbonamenti.datafine%type;
  cursor c_abb is
    select abbonamenti.idAbbonamento , tipiabbonamenti.tipoabbonamento, abbonamenti.datainizio, abbonamenti.datafine
      from clienti
      join abbonamenti on clienti.idCliente=abbonamenti.idCliente
	  join tipiabbonamenti on abbonamenti.idTipoAbbonamento = tipiabbonamenti.idTipoAbbonamento
      where abbonamenti.idAbbonamento=Abb;

  v_ass assicurazioni.idAssicurazione%type;
  v_desc assicurazioni.descrizione%type;
  v_costo assicurazioni.costomensile%type;
  cursor c_ass (Abb_ref abbonamenti.idAbbonamento%type ) is
    select assicurazioni.idAssicurazione,assicurazioni.descrizione,assicurazioni.costomensile
      from abbonamenti join assicurazioni on abbonamenti.idAbbonamento = assicurazioni.idAbbonamento
      where abbonamenti.idAbbonamento=Abb_ref;

    Abbonamento_non_trovato exception;

  begin
	if(ruolo = 'C') then
    open c_abb;
    fetch c_abb into v_abb, v_abb_t, v_abb_i ,v_abb_f;
    if c_abb%NotFound then raise Abbonamento_non_trovato; end if;
    --v_abb contiene riferimento ad abbonamento oppure sono crashato
    modGUI.apriPagina('HoC | Visualizza Assicurazione', id_Sessione , nome, ruolo);
    modGUI.aCapo;
    modGUI.apriIntestazione(2);
        modGUI.inserisciTesto('VISUALIZZA ASSICURAZIONE PER ABBONAMENTO');
    modGUI.chiudiIntestazione(2);
    while c_abb%Found loop
        open c_ass(v_abb);
        fetch c_ass into v_ass,v_desc,v_costo ;
			modGUI.apriIntestazione(3);
                modgui.inserisciTesto('Abbonamento '||v_abb_t||' (valido da '||v_abb_i||' a '|| v_abb_f ||')');
			modGUI.chiudiIntestazione(3);
        if c_ass%NotFound then
                modGUI.apriForm('gruppo3.richiediAssicurazione');
					modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
					modGUI.inserisciInputHidden('nome',nome);
					modGUI.inserisciInputHidden('ruolo',ruolo);
					modGUI.inserisciInputHidden('var_idAbbonamento',v_abb);
					modGUI.inserisciTesto('Non hai nessuna assicurazione attiva, richiedine una adesso.');
					modGUI.aCapo;
					modGUI.aCapo;
					modGUI.apriSelect(nome=>'var_costomensile',etichetta=>'Tipo Assicurazione',richiesto=>true);
					modGUI.inserisciOpzioneSelect(valore=>'20',etichetta=>'BASE',selezionato=>true);
					modGUI.inserisciOpzioneSelect(valore=>'35',etichetta=>'PREMIUM');
					modGUI.inserisciOpzioneSelect(valore=>'50',etichetta=>'SUPER PREMIUM');
					modGUI.chiudiSelect;
					modGUI.inserisciBottoneForm('Richiedi Assicurazione');

                modGUI.chiudiForm;

        else
            --v_ass contiene riferimento ad assicurazione oppure sono crashato
				modGUI.apriTabella;
                modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('Descrizione');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(v_desc);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;

                modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('Costo mensile');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(v_costo);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
				modGUI.chiudiTabella;
        end if;
        close c_ass;
    fetch c_abb into v_abb, v_abb_t, v_abb_i ,v_abb_f;
    end loop;
	modGUI.chiudiPagina;

	else
		modGUI.apriPagina('Errore', id_Sessione, nome, ruolo);
		modGUI.esitoOperazione('KO', 'Non hai permessi per effettuare questa operazione');
		modGUI.apriDiv(centrato=>true);
			modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.ScelgiAbbonamento', 'defFormButton');
		modGUI.chiudiDiv;
	modGUI.chiudiPagina;
	end if;
  exception
    when Abbonamento_non_trovato then
        begin
            modGUI.apriPagina('HoC | Visualizza Assicurazione', id_Sessione , nome, ruolo);
            modGUI.aCapo;
            modGUI.aCapo;
            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('VISUALIZZA ASSICURAZIONE PER ABBONAMENTO');
        	modGUI.chiudiIntestazione(2);
			modGUI.aCapo;
			modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('Non � presente alcun abbonamento attivo.');
        	modGUI.chiudiIntestazione(3);
        end;
end VisualizzaAssicurazioneAbb ;







procedure richiediAssicurazione(id_Sessione varchar2, nome varchar2, ruolo varchar2, var_idAbbonamento varchar2, var_costomensile number) is
    var_descrizione varchar(20);
begin
		if(var_costomensile = 20) then var_descrizione := 'Base'; end if;
		if(var_costomensile = 35) then var_descrizione := 'Premium'; end if;
		if(var_costomensile = 50) then var_descrizione := 'Super Premium'; end if;

		INSERT INTO Assicurazioni VALUES (AssicurazioniSeq.NEXTVAL, var_descrizione,
		var_costomensile, 'F', var_idAbbonamento);

		modGUI.apriPagina('HoC | Richiedi Assicurazione', id_Sessione, nome, ruolo);
			modGUI.esitoOperazione('OK','Attivazione assicurazione avvenuta con successo!');
			modGUI.apriDiv(centrato=>true);
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.ScegliAbbonamento', 'defFormButton');
			modGUI.chiudiDiv;
		modGUI.chiudiPagina;
end richiediAssicurazione;


--Ingressi


procedure procCronologiaAbbonamento(id_Sessione varchar2, nome varchar2, ruolo varchar2, Abb abbonamenti.idAbbonamento%type)
is
begin
    modGUI.apriPagina('HoC | Cronologia Accessi', id_Sessione, nome, ruolo);

    modGUI.aCapo;
    modGUI.apriIntestazione(2);
      modGUI.inserisciTesto('Cronologia dei vari accessi');
    modGUI.chiudiIntestazione(2);
    modGUI.apriDiv;
      modGUI.ApriTabella;

        modGUI.ApriRigaTabella;
          modGUI.intestazioneTabella('Nome');
          modGUI.intestazioneTabella('Cognome');
          modGUI.intestazioneTabella('Entrata');
          modGUI.intestazioneTabella('Uscita');
        modGUI.ChiudiRigaTabella;

        for cronologia in (
          select distinct p.nome ,p.cognome ,oraentrata, orauscita
          from sessioni s, persone p, clienti c, abbonamenti a, ingressiabbonamenti ia
          where s.idpersona = p.idpersona AND
                p.idpersona = c.idpersona AND
                c.idcliente = a.idcliente AND
                a.idabbonamento = ia.idabbonamento AND
                a.idabbonamento=Abb
          order by oraentrata
        )
        loop
          modGUI.ApriRigaTabella;
            modGUI.ApriElementoTabella;
              modGUI.ElementoTabella(cronologia.cognome);
            modGUI.ChiudiElementoTabella;
            modGUI.ApriElementoTabella;
              modGUI.ElementoTabella(cronologia.nome);
            modGUI.ChiudiElementoTabella;
            modGUI.ApriElementoTabella;
              modGUI.ElementoTabella(cronologia.oraentrata);
            modGUI.ChiudiElementoTabella;
            modGUI.ApriElementoTabella;
              modGUI.ElementoTabella(cronologia.orauscita);
            modGUI.ChiudiElementoTabella;
          modGUI.ChiudiRigaTabella;
        end loop;

      modGUI.ChiudiTabella;
    modGUI.chiudiDiv;
    modGUI.apriDiv(centrato=>true);
      modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.ScegliAbbonamento', 'defFormButton');
    modGUI.chiudiDiv;
    modGUI.chiudiPagina;
  end procCronologiaAbbonamento;





procedure procCronologia(id_Sessione varchar2, nome varchar2, ruolo varchar2) is
  begin

    modGUI.apriPagina('HoC | Cronologia Accessi', id_Sessione, nome, ruolo);

    modGUI.aCapo;
    modGUI.apriIntestazione(2);
      modGUI.inserisciTesto('Cronologia dei vari accessi');
    modGUI.chiudiIntestazione(2);
    modGUI.apriDiv;
      modGUI.ApriTabella;

        modGUI.ApriRigaTabella;
          modGUI.intestazioneTabella('ID Abbonamento');
          modGUI.intestazioneTabella('Entrata');
          modGUI.intestazioneTabella('Uscita');
        modGUI.ChiudiRigaTabella;

        for cronologia in (
          select distinct a.idabbonamento, oraentrata, orauscita
          from sessioni s, persone p, clienti c, abbonamenti a, ingressiabbonamenti ia
          where s.idpersona = p.idpersona AND
                p.idpersona = c.idpersona AND
                c.idcliente = a.idcliente AND
                a.idabbonamento = ia.idabbonamento AND
                s.idsessione = id_Sessione
          order by oraentrata
        )
        loop
          modGUI.ApriRigaTabella;
            modGUI.ApriElementoTabella;
              modGUI.ElementoTabella(cronologia.idabbonamento);
            modGUI.ChiudiElementoTabella;
            modGUI.ApriElementoTabella;
              modGUI.ElementoTabella(cronologia.oraentrata);
            modGUI.ChiudiElementoTabella;
            modGUI.ApriElementoTabella;
              modGUI.ElementoTabella(cronologia.orauscita);
            modGUI.ChiudiElementoTabella;
          modGUI.ChiudiRigaTabella;
        end loop;

      modGUI.ChiudiTabella;
    modGUI.chiudiDiv;
    modGUI.apriDiv(centrato=>true);
      modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'checkProprietario', 'defFormButton');
    modGUI.chiudiDiv;
    modGUI.chiudiPagina;

  end procCronologia;





  procedure homeRinnovo(id_Sessione varchar2, nome varchar2, ruolo varchar2) is
  not_enabled exception;

  begin
    if(ruolo != 'C') then raise not_enabled;
    else
    modGUI.apriPagina('HoC | Home Rinnovo Abbonamenti', id_Sessione, nome, ruolo);

      modGUI.aCapo;
      modGUI.apriIntestazione(2);
        modGUI.inserisciTesto('Lista abbonamenti sottoscritti');
      modGUI.chiudiIntestazione(2);
      modGUI.apriDiv;
      modGUI.ApriTabella;

        modGUI.ApriRigaTabella;
        modGUI.intestazioneTabella('Tipo Abbonamento');
        modGUI.intestazioneTabella('Data Inizio');
        modGUI.intestazioneTabella('Data Fine');
        modGUI.intestazioneTabella('Rinnova');
        modGUI.ChiudiRigaTabella;

        for abbonamenti in(
          select idabbonamento, tipoabbonamento, datainizio, datafine
          from   sessioni s, persone p, clienti c, abbonamenti a, tipiabbonamenti ta
          where  s.idpersona = p.idpersona AND
                 c.idpersona = p.idpersona AND
                 a.idcliente = c.idcliente AND
                 ta.idtipoabbonamento = a.idtipoabbonamento AND
                 s.idsessione = id_Sessione
        )
        loop
          modGUI.ApriRigaTabella;
            modGUI.ApriElementoTabella;
              modGUI.ElementoTabella(abbonamenti.tipoabbonamento);
            modGUI.ChiudiElementoTabella;
            modGUI.ApriElementoTabella;
              modGUI.ElementoTabella(abbonamenti.datainizio);
            modGUI.ChiudiElementoTabella;
            modGUI.ApriElementoTabella;
              modGUI.ElementoTabella(abbonamenti.datafine);
            modGUI.ChiudiElementoTabella;
            modGUI.ApriElementoTabella;
              modGUI.inserisciPenna('gruppo3.rinnovoAbbonamenti', id_Sessione, nome, ruolo, abbonamenti.idabbonamento);
            modGUI.ChiudiElementoTabella;
          modGUI.ChiudiRigaTabella;
        end loop;

      modGUI.ChiudiTabella;
      modGUI.chiudiDiv;
    modGUI.chiudiPagina;

    end if;
    exception
      when not_enabled then
        begin
          modGUI.apriPagina('Errore', id_Sessione, nome, ruolo);
            modGUI.esitoOperazione('KO', 'Non hai i permessi per aprire questa pagina');
            --TROVARE UN MODO PER TORNARE ALLA HOME PAGE
             --modGUI.apriDiv(centrato=>true);
               --modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'checkProprietario', 'defFormButton');
             --modGUI.chiudiDiv;
          modGUI.chiudiPagina;
        end;

  end homeRinnovo;




  procedure rinnovoAbbonamenti(id_Sessione varchar2, nome varchar2, ruolo varchar2, idRiga int) as
  v_idcliente blackList.idcliente%type;
  cursor c_black is
    select bl.idcliente
    from sessioni s, persone p, clienti c, blacklist bl
    where s.idpersona = p.idpersona AND
          p.idpersona = c.idpersona AND
          c.idcliente = bl.idcliente AND
          s.idsessione = id_Sessione;
  utente_in_blacklist exception;

  begin

    if (ruolo = 'C') then   /*  Operazione che puo fare solo il cliente */
    open c_black;
    fetch c_black into v_idcliente;
    if c_black%Found then raise utente_in_blacklist;  /*  L' utente è in BlackList non posso rinnovare il suo Abbonamento */
    else
      modGUI.apriPagina('HoC | Rinnovo Abbonamenti', id_Sessione, nome, ruolo);

        modGUI.aCapo;
        modGUI.apriIntestazione(2);
          modGUI.inserisciTesto('Rinnovo Abbonamento');
        modGUI.chiudiIntestazione(2);
        modGUI.apriDiv;

          for abbonamentifor in (
            select datafine, durata, costo
            from  abbonamenti a, tipiabbonamenti ta
            where a.idtipoabbonamento = ta.idtipoabbonamento AND
                  a.idabbonamento = idRiga
          )
          loop
            modGUI.ApriTabella;
              modGUI.ApriRigaTabella;
                modGUI.intestazioneTabella('Vecchia data fine');
                  modGUI.ApriElementoTabella;
                    modGUI.ElementoTabella(abbonamentifor.datafine);
                  modGUI.ChiudiElementoTabella;
              modGUI.ChiudiRigaTabella;

              modGUI.ApriRigaTabella;
                modGUI.intestazioneTabella('Nuova data fine');
                  modGUI.ApriElementoTabella;
                    modGUI.ElementoTabella(abbonamentifor.datafine + abbonamentifor.durata);
                  modGUI.ChiudiElementoTabella;
              modGUI.ChiudiRigaTabella;

              modGUI.ApriRigaTabella;
                modGUI.intestazioneTabella('Spesa');
                  modGUI.ApriElementoTabella;
                    modGUI.ElementoTabella(abbonamentifor.costo);
                  modGUI.ChiudiElementoTabella;
              modGUI.ChiudiRigaTabella;
            modGUI.ChiudiTabella;

            modGUI.apriForm('gruppo3.updateAbb');
              modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
              modGUI.inserisciInputHidden('nome',nome);
              modGUI.inserisciInputHidden('ruolo',ruolo);
              modGUI.inserisciInputHidden('idRiga', idRiga);
              modGUI.inserisciInputHidden('var_durata', abbonamentifor.durata);
              modGUI.inserisciBottoneForm('Paga');
            modGUI.chiudiForm;
            modGUI.apriDiv(centrato=>true);
              modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.homeRinnovo', 'defFormButton');
            modGUI.chiudiDiv;
          end loop;
        modGUI.chiudiDiv;

      modGUI.chiudiPagina;
    end if;
    else
    modGUI.apriPagina('Errore', id_Sessione, nome, ruolo);
      modGUI.esitoOperazione('KO', 'Non hai permessi per effettuare questa operazione');
       modGUI.apriDiv(centrato=>true);
         modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.homeRinnovo', 'defFormButton');
       modGUI.chiudiDiv;
    modGUI.chiudiPagina;
    end if;

    exception
    when utente_in_blacklist then
      begin
        modGUI.apriPagina('Errore', id_Sessione, nome, ruolo);
          modGUI.esitoOperazione('KO', 'Utente in BlackList, impossibile rinnovare');
           modGUI.apriDiv(centrato=>true);
             modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.homeRinnovo', 'defFormButton');
           modGUI.chiudiDiv;
        modGUI.chiudiPagina;
      end;

  end;


  procedure updateAbb(id_Sessione varchar2, nome varchar2, ruolo varchar2, idRiga int, var_durata number) is
  begin
    modGUI.apriPagina('HoC | Update Abbonamenti', id_Sessione, nome, ruolo);

      UPDATE  abbonamenti
      SET abbonamenti.datafine = abbonamenti.datafine + var_durata
      WHERE abbonamenti.idabbonamento = idRiga;

      modGUI.esitoOperazione('OK', 'Rinnovo avvenuto correttamente');
      modGUI.apriDiv(centrato=>true);
        modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.ScegliAbbonamento', 'defFormButton');
      modGUI.chiudiDiv;
    modGUI.chiudiPagina;

  end updateAbb;




  procedure Parcheggio_Abb(
      IdAbb abbonamenti.idAbbonamento%type,
      IdVei veicoli.idVeicolo%type,
      IdCli clienti.idcliente%type
  )
  is
    v_area aree.idArea%type;
    v_box box.idBox%Type;
    RightBoxNotFound exception;

  begin
    v_area:=gruppo3.Ass_area_min(IdVei);
  -- trova box riservato per questo veicolo e questo abbonamento
  -- ogni veicolo nella lista veicoli di un abbonamento ha un posto riservato nell'area piu adatta a contenerlo
  --non si puo fare la ricerca solo per box.idAbbonamento perche rischio di occupare il posto che era
  --stato riservato ad un veicolo piu grosso legato allo stesso abbonamento
    select box.idBox into v_box
      from box join aree on box.idArea=aree.idArea
        where aree.idArea= v_area and box.idAbbonamento= IdAbb;
    if SQL%NotFound then raise RightBoxNotFound; end if;
  --v_box contiene il box riservato per QUESTO veicolo
  --inserimento in IngressiAbbonamenti fa scattare un trigger che prende idBox appena trovato e lo usa
  --per markare quel box a occupato e decrementare i posti liberi nella relativa area.
    insert into IngressiAbbonamenti values (ingressiAbbonamentiSeq.NEXTVAL, SYSTIMESTAMP , null, 'F' , IdAbb , v_box , null );
    insert into EffettuaIngressiAbbonamenti values (IdVei,IdCli,ingressiAbbonamentiSeq.CURRVAL);
  end Parcheggio_Abb;




  procedure ritiro_abbonati(Vei veicoli.idVeicolo%type) as
    IngressoInesistenteOConcluso exception;
  begin
    update IngressiAbbonamenti set OraUscita = SYSTIMESTAMP where idIngressoAbbonamento = (select IngressiAbbonamenti.idIngressoAbbonamento
      from IngressiAbbonamenti join EffettuaIngressiAbbonamenti on EffettuaIngressiAbbonamenti.idIngressoAbbonamento= IngressiAbbonamenti.idIngressoAbbonamento
      where EffettuaIngressiAbbonamenti.idVeicolo =vei and OraUscita=null);
    if SQL%NotFound then raise IngressoInesistenteOConcluso; end if;
  end;





  function Ass_area_min(
      Vei veicoli.idVeicolo%type
  )
  return aree.idArea%type as
  --caratteristiche del veicolo a cui devo assegnare area
      act_lungh veicoli.lunghezza%type;
      act_largh veicoli.larghezza%type;
      act_altez veicoli.altezza%type;
      act_peso  veicoli.peso%type;
      act_alim  veicoli.alimentazione%type;
  --cursore per aree adatte a contenere il veicolo
      cursor c_aree is
          select idArea, LunghezzaMax, LarghezzaMax, AltezzaMax, PesoMax
              from aree
                  where LunghezzaMax > act_lungh and
                  LarghezzaMax > act_largh and
                  AltezzaMax > act_altez and
                  PesoMax > act_peso and
                  not ( ( Gas = 'T' ) ) or act_alim = 'GPL' ;
      r_area c_aree%RowType;
  --area predestinata
      r_area_min c_aree%RowType;
  begin
  --reperisco caratteristiche del veicolo
      select lunghezza, larghezza, altezza,   peso,     alimentazione
      into   act_lungh, act_largh, act_altez, act_peso, act_alim
          from veicoli
          where idVeicolo=Vei;
      if SQL%NotFound then return null; end if;
      open c_aree;
      fetch c_aree into r_area_min;
      if c_aree%NotFound then return null; end if;
  --non uso ciclo for perche mi serve la prima tupla
      loop
      --tra tutte le aree che possono contenere il veicolo prendo la piu piccola.
      --le aree sono inserite mantenendo una certa proprieta' "matrioska",quindi considero tutti i valori
          fetch c_aree into r_area;
          exit when c_aree%NotFound;
          if
              r_area.lunghezzaMax <= r_area_min.lunghezzaMax and
              r_area.larghezzaMax <= r_area_min.larghezzaMax and
              r_area.altezzaMax <= r_area_min.altezzaMax and
              r_area.pesoMax <= r_area_min.pesoMax
          then r_area_min := r_area;
          end if;
      end loop;
      return r_area_min.idArea;
    exception
        when no_data_found then
            modGUI.apriPagina('HoC | Update Abbonamenti', 101, 'Cliente', 'C');


  end Ass_area_min;





  function ContrAbb (id_Cli in clienti.idCliente%type, id_Vei in veicoli.idVeicolo%type)
  return abbonamenti.idabbonamento%type as
    v_data_fine abbonamenti.DataFine%type;
    v_ora_inizio tipiabbonamenti.orafine%type;
    v_ora_fine tipiabbonamenti.orainizio%type;
    v_veicolo abbonamentiveicoli.idveicolo%type;
    current_time timestamp:=LOCALTIMESTAMP();
    dataok boolean;
    fasciaok boolean;
    v_hour int;
  begin
  --unione abbonamenti che cliente possiede con abbonamenti che il cliente puo usare
    for id_abb in (select abbonamenti.idAbbonamento
      from abbonamenti join clienti on abbonamenti.idCliente=clienti.idCliente
      where clienti.idCliente = id_Cli
      union
    select AbbonamentiClienti.idAbbonamento
      from clienti join AbbonamentiClienti on AbbonamentiClienti.idCliente=clienti.idCliente
      where clienti.idCliente = id_Cli)
      --non PUO USARE un abbonamento,ne ne possiede uno, quindi ritorno null
      loop
        --id_abb contiene un abbonamento che il cliente possiede o puo usare:
        --controllo che nei veicoli autorizzati per questo abbonamento sia presente il veicolo dato
        select abbonamentiveicoli.idveicolo into v_veicolo
          from AbbonamentiVeicoli join abbonamenti on AbbonamentiVeicoli.idAbbonamento =abbonamenti.idAbbonamento
          where AbbonamentiVeicoli.idVeicolo= id_Vei and abbonamenti.idAbbonamento=id_Abb.idAbbonamento;
        if sql%NotFound then goto loopend; end if;
        --id_abb contiene abbonamento utilizzabile oppure sono passato al prossimo abbonamento
        select abbonamenti.DataFine, tipiabbonamenti.orainizio, tipiabbonamenti.orafine into v_data_fine, v_ora_inizio, v_ora_fine
         from abbonamenti join tipiabbonamenti on abbonamenti.idtipoabbonamento = tipiabbonamenti.idtipoabbonamento
         where abbonamenti.idAbbonamento = id_Abb.idAbbonamento;
        --controllo validita dati fetchati
        dataok := v_data_fine < current_date;
        v_hour := EXTRACT(HOUR FROM current_time);
        fasciaok:= (v_hour >= v_ora_inizio) and (v_hour <= v_ora_fine);
        --se tutte le condizioni sono rispettate restituisco id abbonam.
        if fasciaok and dataok then return id_abb.idAbbonamento; end if;
        <<loopend>>
        fasciaok:=false;
        dataok:=false;
      end loop;
    --altrimenti null
    return null;
  end ContrAbb;




  procedure dettagliTipiAbb(id_Sessione varchar2, nome varchar2, ruolo varchar2, idRiga varchar2) is
begin
	modGUI.apriPagina('HoC | Dettagli Tipi Abb', id_Sessione, nome, ruolo);
		modGUI.aCapo;
		modGUI.apriIntestazione(2);
			modGUI.inserisciTesto('DETTAGLI TIPI ABBONAMENTI');
		modGUI.chiudiIntestazione(2);

		modGUI.apriDiv;
		for tipiabbonamenti in
			(SELECT idTipoAbbonamento, maxveicoli, maxclienti, maxautorimesse, durata, costo, tipoabbonamento, orainizio, orafine
			FROM tipiabbonamenti
			WHERE
			tipiabbonamenti.idTipoAbbonamento=idRiga)
		loop
		modGUI.ApriTabella;

			modGUI.ApriRigaTabella;
				modGUI.intestazioneTabella('TIPO ABBONAMENTO');
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(tipiabbonamenti.tipoabbonamento);
					modGUI.ChiudiElementoTabella;
			modGUI.ChiudiRigaTabella;

			modGUI.ApriRigaTabella;
				modGUI.intestazioneTabella('MAX VEICOLI');
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(tipiabbonamenti.maxveicoli);
					modGUI.ChiudiElementoTabella;
			modGUI.ChiudiRigaTabella;

			modGUI.ApriRigaTabella;
				modGUI.intestazioneTabella('MAX CLIENTI');
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(tipiabbonamenti.maxveicoli);
					modGUI.ChiudiElementoTabella;
			modGUI.ChiudiRigaTabella;

			modGUI.ApriRigaTabella;
				modGUI.intestazioneTabella('MAX AUTORIMESSE');
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(tipiabbonamenti.maxautorimesse);
					modGUI.ChiudiElementoTabella;
			modGUI.ChiudiRigaTabella;

			modGUI.ApriRigaTabella;
				modGUI.intestazioneTabella('DURATA');
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(tipiabbonamenti.durata);
					modGUI.ChiudiElementoTabella;
			modGUI.ChiudiRigaTabella;

			modGUI.ApriRigaTabella;
				modGUI.intestazioneTabella('COSTO');
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(tipiabbonamenti.costo);
					modGUI.ChiudiElementoTabella;
			modGUI.ChiudiRigaTabella;

			modGUI.ApriRigaTabella;
				modGUI.intestazioneTabella('ORA INIZIO');
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(tipiabbonamenti.orainizio);
					modGUI.ChiudiElementoTabella;
			modGUI.ChiudiRigaTabella;

			modGUI.ApriRigaTabella;
				modGUI.intestazioneTabella('ORA FINE');
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(tipiabbonamenti.orafine);
					modGUI.ChiudiElementoTabella;
			modGUI.ChiudiRigaTabella;

		modGUI.ChiudiTabella;
		end loop;

		modGUI.apriIntestazione(3);
				modGUI.inserisciTesto('ALTRE OPERAZIONI');
		modGUI.chiudiIntestazione(3);

		modGUI.apriDiv(centrato=>true);
			modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.visualizzaTipiAbb', 'defFormButton');
		modGUI.chiudiDiv;
		modGUI.aCapo;

	modGUI.chiudiPagina;
end dettagliTipiAbb;




procedure visualizzaTipiAbb(id_Sessione varchar2, nome varchar2, ruolo varchar2, idRiga varchar2 default 0) is

var_idtipoabb tipiabbonamenti.idTipoAbbonamento%TYPE;
var_tipoabb tipiabbonamenti.TipoAbbonamento%TYPE;
var_maxveicoli tipiabbonamenti.maxveicoli%TYPE;
var_maxclienti tipiabbonamenti.maxclienti%TYPE;
var_maxautorimesse tipiabbonamenti.maxautorimesse%TYPE;
var_durata tipiabbonamenti.durata%TYPE;
var_costo tipiabbonamenti.costo%TYPE;
var_orainizio tipiabbonamenti.orainizio%TYPE;
var_orafine tipiabbonamenti.orafine%TYPE;
cursor var_tipiabb is
SELECT idTipoAbbonamento, TipoAbbonamento, maxveicoli, maxclienti, maxautorimesse, durata, costo, orainizio, orafine
FROM tipiabbonamenti ORDER BY idTipoAbbonamento;

TipoAbbonamentoNonTrovato exception;

begin
 modGUI.apriPagina('HoC | Visualizza Tipi Abb', id_Sessione, nome, ruolo);

	modGUI.aCapo;
	modGUI.apriIntestazione(2);
		modGUI.inserisciTesto('VISUALIZZA TIPI ABBONAMENTI');
	modGUI.chiudiIntestazione(2);
	modGUI.apriDiv;
		modGUI.ApriTabella;

			modGUI.ApriRigaTabella;
				modGUI.intestazioneTabella('Tipo Abbonamento');
				modGUI.intestazioneTabella('Max Veicoli');
				modGUI.intestazioneTabella('Max Clienti');
                modGUI.intestazioneTabella('Max Autorimesse');
                modGUI.intestazioneTabella('Durata');
                modGUI.intestazioneTabella('Costo');
				modGUI.intestazioneTabella('Ora Inizio');
				modGUI.intestazioneTabella('Ora Fine');
				modGUI.intestazioneTabella('Operazioni');
			modGUI.ChiudiRigaTabella;

			open var_tipiabb; /* CURSORE APERTO, ----> USARE CURSORE ESPLICITO A QUESTO PUNTO??------*/

			fetch var_tipiabb into var_idtipoabb, var_tipoabb, var_maxveicoli, var_maxclienti, var_maxautorimesse, var_durata, var_costo, var_orainizio, var_orafine;

			if var_tipiabb%NotFound then
				raise TipoAbbonamentoNonTrovato;
			end if;

			while var_tipiabb%Found
			loop
				modGUI.ApriRigaTabella;
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(var_tipoabb);
					modGUI.ChiudiElementoTabella;
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(var_maxveicoli);
					modGUI.ChiudiElementoTabella;
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(var_maxclienti);
					modGUI.ChiudiElementoTabella;
                    modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(var_maxautorimesse);
					modGUI.ChiudiElementoTabella;
                    modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(var_durata);
					modGUI.ChiudiElementoTabella;
                    modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(var_costo);
					modGUI.ChiudiElementoTabella;
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(var_orainizio);
					modGUI.ChiudiElementoTabella;
					modGUI.ApriElementoTabella;
						modGUI.ElementoTabella(var_orafine);
					modGUI.ChiudiElementoTabella;
					modGUI.ApriElementoTabella;
						modGUI.inserisciLente('gruppo3.dettagliTipiAbb', id_Sessione, nome, ruolo, var_idtipoabb);
						modGUI.inserisciPenna('gruppo3.modificaTipiAbb', id_Sessione, nome, ruolo, var_idtipoabb);
					modGUI.ChiudiElementoTabella;
				modGUI.ChiudiRigaTabella;
				fetch var_tipiabb into var_idtipoabb, var_tipoabb, var_maxveicoli, var_maxclienti, var_maxautorimesse, var_durata, var_costo, var_orainizio, var_orafine;
			end loop;

			close var_tipiabb;

		modGUI.ChiudiTabella;
	modGUI.chiudiDiv;

	modGUI.apriIntestazione(3);
		modGUI.inserisciTesto('ALTRE OPERAZIONI');
	modGUI.chiudiIntestazione(3);
	modGUI.apriDiv(centrato=>true);
		modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Inserisci Tipo Abbonamento', 'gruppo3.inserisciTipiAbb', 'defFormButton');
	modGUI.chiudiDiv;

 modGUI.chiudiPagina;

 exception
    when TipoAbbonamentoNonTrovato then
        begin
            modGUI.apriPagina('HoC | Visualizza Tipi Abb', id_Sessione , nome, ruolo);
            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('VISUALIZZA TIPI ABBONAMENTI');
        	modGUI.chiudiIntestazione(2);
			modGUI.aCapo;
			modGUI.apriIntestazione(3);
			modGUI.inserisciTesto('Non è presente nessun tipo di gruppo3.');
			modGUI.chiudiIntestazione(3);
        end;

end visualizzaTipiAbb;




procedure modificaTipiAbb(id_Sessione varchar2, nome varchar2, ruolo varchar2, idRiga varchar2) is
begin
	if(ruolo = 'R') then
	modGUI.apriPagina('HoC | Modifica Tipi Abb', id_Sessione, nome, ruolo);

		modGUI.aCapo;
		modGUI.apriIntestazione(2);
			modGUI.inserisciTesto('MODIFICA TIPO ABBONAMENTO');
		modGUI.chiudiIntestazione(2);


		modGUI.apriForm('modificaTipiAbbDati');

			modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
			modGUI.inserisciInputHidden('nome',nome);
			modGUI.inserisciInputHidden('ruolo',ruolo);
			modGUI.inserisciInputHidden('var_idTipoAbbonamento', idRiga);
			for tipiabbonamenti in
			(SELECT idTipoAbbonamento, maxveicoli, maxclienti, maxautorimesse, durata, costo, tipoabbonamento, orainizio, orafine
			FROM tipiabbonamenti
			WHERE
			tipiabbonamenti.idTipoAbbonamento=idRiga)
			loop
				modGUI.inserisciTesto('Max Veicoli');
				modGUI.inserisciInput(nome=>'var_maxveicoli', etichetta=>'Max Veicoli', tipo=>'number', richiesto=>true, valore=>tipiabbonamenti.maxveicoli);

				modGUI.inserisciTesto('Max Clienti');
				modGUI.inserisciInput(nome=>'var_maxclienti', etichetta=>'Max Clienti', tipo=>'number', richiesto=>true, valore=>tipiabbonamenti.maxclienti);

				modGUI.inserisciTesto('Max Autorimesse');
				modGUI.inserisciInput(nome=>'var_maxautorimesse', etichetta=>'Max Autorimesse', tipo=>'number', richiesto=>true, valore=>tipiabbonamenti.maxautorimesse);

				modGUI.inserisciTesto('Durata');
				modGUI.inserisciInput(nome=>'var_durata', etichetta=>'Durata', tipo=>'number', richiesto=>true, valore=>tipiabbonamenti.durata);

				modGUI.inserisciTesto('Costo');
				modGUI.inserisciInput(nome=>'var_costo', etichetta=>'Costo', tipo=>'number', richiesto=>true, valore=>tipiabbonamenti.costo);

				modGUI.inserisciTesto('Tipo Abbonamento');
				modGUI.inserisciInput(nome=>'var_tipoabbonamento', etichetta=>'Tipo Abbonamento', tipo=>'text', richiesto=>true, valore=>tipiabbonamenti.tipoabbonamento);

				modGUI.inserisciTesto('Ora Inizio');
				modGUI.inserisciInput(nome=>'var_orainizio', etichetta=>'Ora Inizio', tipo=>'number', richiesto=>true, valore=>tipiabbonamenti.orainizio);

				modGUI.inserisciTesto('Ora Fine');
				modGUI.inserisciInput(nome=>'var_orafine', etichetta=>'Ora Fine', tipo=>'number', richiesto=>true, valore=>tipiabbonamenti.orafine);

			end loop;

			modGUI.inserisciBottoneReset(testo=>'Reset');
			modGUI.inserisciBottoneForm(testo=>'Modifica');
		modGUI.chiudiForm;
		modGUI.aCapo;
	modGUI.chiudiPagina;
	else
	modGUI.apriPagina('Errore', id_Sessione, nome, ruolo);
		modGUI.esitoOperazione('KO', 'Non hai permessi per effettuare questa operazione');
		modGUI.apriDiv(centrato=>true);
			modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.visualizzaTipiAbb', 'defFormButton');
		modGUI.chiudiDiv;
	modGUI.chiudiPagina;
	end if;
end modificaTipiAbb;





procedure inserisciTipiAbbDati(id_Sessione varchar2, nome varchar2, ruolo varchar2, var_maxveicoli number,
var_maxclienti number, var_maxautorimesse number, var_durata number, var_costo number, var_tipoabbonamento varchar2,
var_orainizio number, var_orafine number) is

begin
	if((var_orainizio >= 0 AND var_orainizio <=23) AND (var_orafine >= 0 AND var_orafine <=23)) then
		INSERT INTO TipiAbbonamenti VALUES (TipiAbbonamentiSeq.NEXTVAL, var_maxveicoli,
		var_maxclienti, var_maxautorimesse, var_durata, var_costo,
		var_tipoabbonamento, var_orainizio, var_orafine);




		modGUI.apriPagina('HoC | Inserisci Tipi Abb', id_Sessione, nome, ruolo);
			modGUI.esitoOperazione('OK','Inserimento del tipo abbonamento avvenuto correttamente.');
			modGUI.apriDiv(centrato=>true);
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.inserisciTipiAbb', 'defFormButton');
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Visualizza Tipi Abbonamenti', 'gruppo3.visualizzaTipiAbb', 'defFormButton');
			modGUI.chiudiDiv;
		modGUI.chiudiPagina;
	else

		modGUI.apriPagina('HoC | Inserisci Tipi Abb', id_Sessione, nome, ruolo);
			modGUI.esitoOperazione('KO','Inserimento non avvenuto correttamente, controllare formato ora inizio e ora fine.');
			modGUI.apriDiv(centrato=>true);
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.inserisciTipiAbb', 'defFormButton');
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Visualizza Tipi Abbonamenti', 'gruppo3.visualizzaTipiAbb', 'defFormButton');
			modGUI.chiudiDiv;
		modGUI.chiudiPagina;
	end if;

	exception
	when DUP_VAL_ON_INDEX then
		modGUI.apriPagina('HoC | Inserisci Tipi Abb', id_Sessione, nome, ruolo);
			modGUI.esitoOperazione('KO','Inserimento non è avvenuto correttamente, tipo abbonamento già esistente.');
			modGUI.apriDiv(centrato=>true);
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.inserisciTipiAbb', 'defFormButton');
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Visualizza Tipi Abbonamenti', 'gruppo3.visualizzaTipiAbb', 'defFormButton');
			modGUI.chiudiDiv;
		modGUI.chiudiPagina;

end inserisciTipiAbbDati;





procedure inserisciTipiAbb(id_Sessione varchar2, nome varchar2, ruolo varchar2) is
begin
	if(ruolo = 'R') then
	modGUI.apriPagina('HoC | Inserisci Tipi Abb', id_Sessione, nome, ruolo);

		modGUI.aCapo;
		modGUI.apriIntestazione(2);
			modGUI.inserisciTesto('INSERISCI TIPO ABBONAMENTO');
		modGUI.chiudiIntestazione(2);


		modGUI.apriForm('gruppo3.inserisciTipiAbbDati');

			modGUI.inserisciInputHidden('id_Sessione',id_Sessione);
			modGUI.inserisciInputHidden('nome',nome);
			modGUI.inserisciInputHidden('ruolo',ruolo);

			modGUI.inserisciTesto('Max Veicoli');
			modGUI.inserisciInput(nome=>'var_maxveicoli', etichetta=>'Max Veicoli', tipo=>'number', richiesto=>true);

			modGUI.inserisciTesto('Max Clienti');
			modGUI.inserisciInput(nome=>'var_maxclienti', etichetta=>'Max Clienti', tipo=>'number', richiesto=>true);

			modGUI.inserisciTesto('Max Autorimesse');
			modGUI.inserisciInput(nome=>'var_maxautorimesse', etichetta=>'Max Autorimesse', tipo=>'number', richiesto=>true);

			modGUI.inserisciTesto('Durata');
			modGUI.inserisciInput(nome=>'var_durata', etichetta=>'Durata', tipo=>'number', richiesto=>true);

			modGUI.inserisciTesto('Costo');
			modGUI.inserisciInput(nome=>'var_costo', etichetta=>'Costo', tipo=>'number', richiesto=>true);

			modGUI.inserisciTesto('Tipo Abbonamento');
			modGUI.inserisciInput(nome=>'var_tipoabbonamento', etichetta=>'Tipo Abbonamento', tipo=>'text', richiesto=>true);

			modGUI.inserisciTesto('Ora Inizio');
			modGUI.inserisciInput(nome=>'var_orainizio', etichetta=>'Ora Inizio', tipo=>'number', richiesto=>true);

			modGUI.inserisciTesto('Ora Fine');
			modGUI.inserisciInput(nome=>'var_orafine', etichetta=>'Ora Fine', tipo=>'number', richiesto=>true);

			modGUI.inserisciBottoneReset(testo=>'Reset');
			modGUI.inserisciBottoneForm(testo=>'Inserisci');
		modGUI.chiudiForm;
		modGUI.aCapo;
	modGUI.chiudiPagina;
	else
	modGUI.apriPagina('Errore', id_Sessione, nome, ruolo);
		modGUI.esitoOperazione('KO', 'Non hai permessi per effettuare questa operazione');
		modGUI.apriDiv(centrato=>true);
			modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.visualizzaTipiAbb', 'defFormButton');
		modGUI.chiudiDiv;
	modGUI.chiudiPagina;
	end if;
end inserisciTipiAbb;






 procedure modificaTipiAbbDati(id_Sessione varchar2, nome varchar2, ruolo varchar2, var_idTipoAbbonamento varchar2, var_maxveicoli number,
var_maxclienti number, var_maxautorimesse number, var_durata number, var_costo number, var_tipoabbonamento varchar2,
var_orainizio number, var_orafine number) is

begin
	if((var_orainizio >= 0 AND var_orainizio <=23) AND (var_orafine >= 0 AND var_orafine <=23)) then
		UPDATE TipiAbbonamenti
		SET maxveicoli = var_maxveicoli, maxclienti = var_maxclienti,
		maxautorimesse = var_maxautorimesse, durata = var_durata,
		costo = var_costo, tipoabbonamento = var_tipoabbonamento,
		orainizio = var_orainizio, orafine = var_orafine
		WHERE idTipoAbbonamento = var_idTipoAbbonamento;

		modGUI.apriPagina('HoC | Modifica Tipi Abb', id_Sessione, nome, ruolo);
			modGUI.esitoOperazione('OK','Modifica del tipo abbonamento avvenuta correttamente.');
			modGUI.apriDiv(centrato=>true);
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.visualizzaTipiAbb', 'defFormButton');
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Visualizza Tipi Abbonamenti', 'gruppo3.visualizzaTipiAbb', 'defFormButton');
			modGUI.chiudiDiv;
		modGUI.chiudiPagina;
	else

		modGUI.apriPagina('HoC | Modifica Tipi Abb', id_Sessione, nome, ruolo);
			modGUI.esitoOperazione('KO','La modifica non è avvenuta correttamente, controllare formato ora inizio e ora fine.');
			modGUI.apriDiv(centrato=>true);
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.visualizzaTipiAbb', 'defFormButton');
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Visualizza Tipi Abbonamenti', 'gruppo3.visualizzaTipiAbb', 'defFormButton');
			modGUI.chiudiDiv;
		modGUI.chiudiPagina;
	end if;

	exception
	when DUP_VAL_ON_INDEX then
		modGUI.apriPagina('HoC | Modifica Tipi Abb', id_Sessione, nome, ruolo);
			modGUI.esitoOperazione('KO','La modifica non è avvenuta correttamente, tipo abbonamento già esistente.');
			modGUI.apriDiv(centrato=>true);
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Indietro', 'gruppo3.inserisciTipiAbb', 'defFormButton');
				modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'Visualizza Tipi Abbonamenti', 'gruppo3.visualizzaTipiAbb', 'defFormButton');
			modGUI.chiudiDiv;
		modGUI.chiudiPagina;

end modificaTipiAbbDati;




procedure IntroitiAbbonamenti(id_Sessione varchar2, nome varchar2, ruolo varchar2, mesi int default -1) is

v_count abbonamenti.CostoEffettivo%type;
target_date date;

begin
 modGUI.apriPagina('HoC | Statistiche', id_Sessione, nome, ruolo);

	modGUI.aCapo;
	modGUI.apriIntestazione(2);
		modGUI.inserisciTesto('totale introiti provenienti da abbonamenti registrati negli ultimi mesi');
	modGUI.chiudiIntestazione(2);
    modGui.aCapo;
    modGui.apriForm('gruppo3.IntroitiAbbonamenti');
        modGui.inserisciinputHidden('id_Sessione', id_Sessione);
        modGui.inserisciinputHidden('nome', nome);
        modGui.inserisciinputHidden('ruolo', ruolo);
        modGui.inserisciInput('mesi', '# mesi', 'number', true , '', 'defInput');
        modGui.inserisciBottoneForm;
    modGui.chiudiForm;

    if mesi > 0 then
        target_date:= add_months(sysdate, -mesi);
        v_count:=0;
        for Abb in (
            select abbonamenti.PagamentiAbbonamenti
                from abbonamenti
                    where DataInizio >= target_date
        )
        loop
            v_count:= v_count + Abb.PagamentiAbbonamenti;
        end loop;
        modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('risultato:');
            modGUI.aCapo;
            modGUI.inserisciTesto(v_count||' € ');
        modGUI.chiudiIntestazione(2);
    end if;


 modGUI.chiudiPagina;

end IntroitiAbbonamenti;




procedure Lista_Veicoli_Abbonamento(id_Sessione int, nome varchar2, ruolo varchar2,abb abbonamenti.idAbbonamento%type)
as
    v_cli Clienti.idCliente%type;
    v_count integer;
        cursor c_veicoli_prop is (select produttore, modello, colore, targa , veicoli.idVeicolo
            from VeicoliClienti join Veicoli on VeicoliClienti.idVeicolo=veicoli.idVeicolo
            where veicoliClienti.idCliente= v_cli);
    r_veicolo c_veicoli_prop%RowType;
    cursor c_veicoli_aut is (
    select produttore, modello, colore, targa , veicoli.idVeicolo, Persone.nome as nomev, Persone.cognome as cognomev
            from VeicoliClienti join Veicoli on VeicoliClienti.idVeicolo=veicoli.idVeicolo
            join Clienti on Clienti.idCliente=VeicoliClienti.idCliente
            join Persone on Persone.idPersona=Clienti.idPersona
            where veicoliClienti.idCliente in ( select Clienti.idCliente
                from AbbonamentiClienti join clienti on AbbonamentiClienti.idcliente=Clienti.idCliente
                where AbbonamentiClienti.idAbbonamento=abb
                )
                --and VeicoliClienti.idCliente != v_cli
                and VeicoliClienti.idVeicolo not in (select VeicoliClienti.idVeicolo
                    from VeicoliClienti
                    where VeicoliClienti.idCliente = v_cli)
    );
    r_veicoli_aut c_veicoli_aut%RowType;
begin
--si rompe se utete possiede piu di un abbonamento bisogna fare un abbonamento_pre per far specificare quale abbonamento si vuole usare
    select Clienti.idCliente into v_cli
        from Abbonamenti join Clienti on Abbonamenti.idCliente=Clienti.idCliente
         where abbonamenti.idAbbonamento=abb;
    modGUI.apriPagina('HoC | Lista Veicoli', id_Sessione, nome, ruolo);
        modGUI.aCapo;
        modGUI.apriIntestazione(1);
            modGUI.inserisciTesto('Lista Veicoli');
        modGUI.chiudiIntestazione(1);
        modGUI.apriDiv;
          modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('veicoli proprietario: ');
          modGui.chiudiIntestazione(2);
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
                select count(*) into v_count from AbbonamentiVeicoli where idAbbonamento=abb and idVeicolo=r_veicolo.idVeicolo;
                    if v_count = 0 then
                        modGUI.apriElementoTabella;
                        modGui.inserisciPenna('gruppo3.Pagamento_Inserimento_veicolo', id_Sessione, nome, ruolo, r_veicolo.idVeicolo||' '||abb );
                        modgui.chiudiElementotabella;
                        modGUI.apriElementoTabella;
                        modgui.inserisciTesto('non presente');
                        modgui.chiudiElementotabella;
                    else
                        modGUI.apriElementoTabella;
                        modGui.InserisciTesto('presente');
                        modgui.chiudiElementotabella;
                        modGUI.apriElementoTabella;
                        modGui.inserisciPenna('gruppo3.Rimuovi_veicolo_abbonamento', id_Sessione, nome, ruolo, r_veicolo.idVeicolo||' '||abb);
                        modgui.chiudiElementotabella;
                    end if;
                modgui.chiudielementotabella;
                modgui.chiudirigatabella;
              fetch c_veicoli_prop into r_veicolo;
              exit when c_veicoli_prop%NotFound;
              end loop;
          else
             modGUI.apriIntestazione(3);
                 modGUI.inserisciTesto('Lista Veicoli proprietario vuota');
             modGUI.chiudiIntestazione(3);
          end if;
          modGui.chiudiTabella;
          modGUI.chiudiDiv;
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
            modgui.intestazionetabella('inserisci');
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
                select count(*) into v_count from AbbonamentiVeicoli where idAbbonamento=abb and idVeicolo=r_veicoli_aut.idVeicolo;
                    if v_count = 0 then
                        modGUI.apriElementoTabella;
                        modGui.inserisciPenna('gruppo3.Inserisci_veicolo_abbonamento2', id_Sessione, nome, ruolo, r_veicoli_aut.idVeicolo||' '||abb );
                        modgui.chiudiElementotabella;
                        modGUI.apriElementoTabella;
                        modgui.inserisciTesto('non presente');
                        modgui.chiudiElementotabella;
                    else
                        modGUI.apriElementoTabella;
                        modGui.InserisciTesto('presente');
                        modgui.chiudiElementotabella;
                        modGUI.apriElementoTabella;
                        modGui.inserisciPenna('gruppo3.Rimuovi_veicolo_abbonamento', id_Sessione, nome, ruolo, r_veicoli_aut.idVeicolo||' '||abb);
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
        modGUI.apriDiv;
      modGUI.chiudiDiv;

     modGUI.chiudiPagina;

    exception
        when no_data_found then
            begin
                modGUI.apriPagina('HoC | Inserisci Veicoli', id_Sessione, nome, ruolo);
                modGui.esitoOperazione('Abbonamento non trovato','a quanto pare non possiedi alcun abbunamento, per questo motivo non puoi manipolare la lista veicoli!');
            end;
 end;

end gruppo3;
