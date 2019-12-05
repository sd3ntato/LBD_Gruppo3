# LBD_Gruppo3

## per aggiungere collegamenti al menu:

### nella procedura creaMenuPrincipale sostituire nella parte riguardante il gruppo 3 il seguente codice:


htp.print('<button class=dropbtn>GRUPPO3</button>');
      modGUI.apriDiv(classe=>'dropdown-content');

      modGUI.Collegamento('Riepilogo abbonamento',  'gruppo3.ScegliAbbonamento?id_Sessione=' || id_Sessione || '&nome=' || nome || '&ruolo=' || ruolo || '&nomeProc=Abbonamento_Center');
      modGUI.Collegamento('Nuovo Abbonamento','gruppo3.sottoscrizioneAbbonamento?id_Sessione=' || id_Sessione || '&nome=' || nome || '&ruolo=' || ruolo);
      modGUI.Collegamento('Check abb deleg','gruppo3.checkDelegati?id_Sessione=' || id_Sessione || '&nome=' || nome || '&ruolo=' || ruolo);
      modGUI.Collegamento('Rinnovo','gruppo3.homeRinnovo?id_Sessione=' || id_Sessione || '&nome=' || nome || '&ruolo=' || ruolo);
      modGUI.Collegamento('Introiti Abbonamenti','gruppo3.IntroitiAbbonamenti?id_Sessione=' || id_Sessione || '&nome=' || nome || '&ruolo=' || ruolo);
      modGUI.Collegamento('Assicurazioni','gruppo3.VisualizzaAssicurazione?id_Sessione=' || id_Sessione || '&nome=' || nome || '&ruolo=' || ruolo);
      modGUI.Collegamento('cronologia','gruppo3.procCronologia?id_Sessione=' || id_Sessione || '&nome=' || nome || '&ruolo=' || ruolo);
      modGUI.Collegamento('tipi Abbonamento','gruppo3.visualizzaTipiAbb?id_Sessione=' || id_Sessione || '&nome=' || nome || '&ruolo=' || ruolo);
      modGUI.Collegamento('aggiungi veicoli','gruppo3.ScegliAbbonamento?id_Sessione=' || id_Sessione || '&nome=' || nome || '&ruolo=' || ruolo || '&nomeProc=Lista_Veicoli_Abbonamento');
