# BM Service — sito demo

Proposta di sito per BM SERVICE di Balzano Michele, officina meccatronica a Manfredonia (FG).

- `index.html` — tutte le pagine (Home, Officina, Servizi, Appuntamento, Contatti, Privacy, Cookie), stile e script
- `img/` — foto illustrative (Pexels, licenza libera): non ritraggono l'officina
- Sezione 3D con Three.js (da cdnjs)

Sito statico, nessuna build. Pubblicato con GitHub Pages. Dati da verificare: orari, P.IVA, foto reali, storia del titolare.
Demo non indicizzata (`noindex`).

## Vendita auto e area riservata

- Pagina pubblica: `#vendita` (filtri, scheda auto, link condivisibile `#auto-<id>`), anteprima in home.
- Area riservata: `#admin` (link "Area riservata" nel footer). Aggiungi / modifica / segna venduta / nascondi / elimina, foto dal telefono (ridimensionate automaticamente).
- **Modalità demo** (attuale): `BM_CONFIG` vuoto in `index.html`. Le modifiche restano sul dispositivo di chi usa il pannello. Gli annunci con etichetta "Esempio" sono dimostrativi.
- **Attivazione reale** (Supabase, piano gratuito):
  1. Creare un progetto Supabase dedicato a BM Service (regione eu-central-1).
  2. Eseguire `supabase-setup.sql` (tabella `cars`, ruoli, bucket foto `auto`, regole di sicurezza).
  3. Authentication → disattivare le iscrizioni pubbliche, creare l'utente del titolare e inserirlo in `admins`.
  4. In `index.html` compilare `BM_CONFIG` con Project URL e chiave pubblica (anon/publishable). Nessuna chiave segreta nel sito.
