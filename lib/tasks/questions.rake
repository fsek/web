namespace :db do
  desc 'Secret'
  task(question_load: :environment) do
    GameQuestion.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('game_questions')

    GameQuestion.create!(question: 'Hur långt var det kortaste styrelsemötet någonsin på hela jorden?',
                         answer1: '19 min',
                         answer2: '7 min',
                         answer3: '32.5 min',
                         correct: 1)
    GameQuestion.create!(question: 'Vilket styrelsemöte var det kortaste styrelsemötet någonsin i världen av världar?',
                         answer1: 'F07VT18',
                         answer2: 'F01VT18',
                         answer3: 'F08HT17',
                         correct: 2)
    GameQuestion.create!(question: 'Vilka var anmodade till spindelkonferensen 2018?',
                         answer1: 'Spindelmännen + prylmästare',
                         answer2: 'Spindelmännen',
                         answer3: 'Spindelmännen + Vladimir "Vlad" Kharlampidi + prylmästare + Linnéa och Jessica',
                         correct: 3)
    GameQuestion.create!(question: 'Vilka var välkomna på spindelkonferensen 2018?',
      answer1: 'Spindelmännen + prylmästare + Vladimir "Vlad" Kharlampidi',
      answer2: 'Spindelmännen',
      answer3: 'Spindelmännen + Vladimir "Vlad" Kharlampidi + prylmästare + Linnéa och Jessica',
                         correct: 1)
    GameQuestion.create!(question: 'Vad är en bapelsin?',
    answer1: 'En banan och apelsins avkomma',
    answer2: 'Ett bäpple från Japan',
    answer3: 'En öl från Emmaboda Bryggeri AB med humlearomatisk smak',
    correct: 3)
    GameQuestion.create!(question: 'Hur lång är the average slips?',
      answer1: '0.9 m',
      answer2: '1.5 m',
      answer3: '1.3 m',
      correct: 2)
    GameQuestion.create!(question: 'Var låg Hilbert café för 50 år sedan?',
      answer1: 'I det som nu är MH:R',
      answer2: 'På tredje våningen',
      answer3: 'Där caféet ligger nu',
      correct: 2)
    GameQuestion.create!(question: 'Hur många bodde i tätorten Torna Hällestad 2017?',
      answer1: '694 st',
      answer2: '1345 st',
      answer3: '510 st',
      correct: 1)
    GameQuestion.create!(question: 'Hur många bodde i Knivsta kommun 2017?',
      answer1: '15689 st',
      answer2: '3547 st',
      answer3: '18064 st',
      correct: 3)
    GameQuestion.create!(question: 'Vad är en kallskänk?',
      answer1: 'donation från okänd',
      answer2: 'plats för tillredning av mat',
      answer3: 'obehaglig överraskning',
      correct: 2)
    GameQuestion.create!(question: 'Vad är Torna Hällestads area?',
      answer1: '83 ha',
      answer2: '80 000 kvadratmeter',
      answer3: '1236 ar',
      correct: 2)
    GameQuestion.create!(question: 'Vad finns inte längre i Caféet?',
      answer1: 'En öltapp',
      answer2: 'En bakmaskin',
      answer3: 'En pool',
      correct: 1)
    GameQuestion.create!(question: 'Vad är Torna Hällestads postnummer?',
      answer1: '247 45',
      answer2: '247 46',
      answer3: '247 47',
      correct: 1)
    GameQuestion.create!(question: 'Vilket föremål blev årets julklapp år 1988?',
      answer1: 'Rubiks kub',
      answer2: 'Bakmaskinen',
      answer3: 'CD-spelare',
      correct: 2)
    GameQuestion.create!(question: 'Vad är F-sektionens organisationsnummer?',
      answer1: '845002-5864',
      answer2: '923120-1744',
      answer3: '845102-5864',
      correct: 1)
    GameQuestion.create!(question: 'Vad är kontot för "Utskottstack" i F-sektionens kontoplan?',
      answer1: '3413',
      answer2: '6610',
      answer3: '7692',
      correct: 3)
    GameQuestion.create!(question: 'Vad är kontot för "Begravningshjälp" enligt BAS-kontoplanen?',
      answer1: '3413',
      answer2: '6610',
      answer3: '7692',
      correct: 3)
    GameQuestion.create!(question: 'Vilket bokföringsprogram använder F-sektionen?',
      answer1: 'Fortnox',
      answer2: 'Visma',
      answer3: 'Bokio',
      correct: 1)
    GameQuestion.create!(question: 'Vad var F-sektionens resultat för verksamhetsåret 2017?',
      answer1: '168 327,26 kr',
      answer2: '162 189,53 kr',
      answer3: '154 355,32 kr',
      correct: 2)
    GameQuestion.create!(question: 'Vad är §9.1 i F-sektionens stadgar?',
      answer1: 'Styrelsens sammansättning',
      answer2: 'Redaktionella ändringar',
      answer3: 'Konflikt',
      correct: 2)
    GameQuestion.create!(question: 'Vad är en linjär älg?',
      answer1: 'En delmängd av ett Hilbertrum',
      answer2: 'En älg som går genom origo',
      answer3: 'En älg vars rygg är rak',
      correct: 2)
    GameQuestion.create!(question: 'Hur mycket är 10?',
      answer1: '10 äpplen',
      answer2: '40 äppleklyftor',
      answer3: '5',
      correct: 3)
    GameQuestion.create!(question: 'Vilken miniräknare använder Jessica?',
      answer1: 'TI-83',
      answer2: 'TI-84',
      answer3: 'TI-84 Plus Silver edition',
      correct: 2)
    GameQuestion.create!(question: 'Vilken miniräknare vill Jessica ha?',
      answer1: 'TI-83',
      answer2: 'TI-84',
      answer3: 'TI-84 Plus Silver edition',
      correct: 3)
    GameQuestion.create!(question: 'Varför vill Jessica ha en annan miniräknare?',
      answer1: 'För den har mer processorkraft',
      answer2: 'För den ritar mjukare kurvor',
      answer3: 'För hon vill kunna spela Pokémon',
      correct: 3)
    GameQuestion.create!(question: 'Varför vill Jessica just ha den miniräknaren till det hon vill ha en annan miniräknare
      till?',
      answer1: 'För den har större minne',
      answer2: 'För den har mer processorkraft',
      answer3: 'För den har utbytbart skal',
      correct: 1)
    GameQuestion.create!(question: 'Vad hittades en dag i cafékylen?',
      answer1: 'En apa',
      answer2: 'En cykel',
      answer3: 'Ett usb-minne',
      correct: 1)
    GameQuestion.create!(question: 'Vad är ett pV-diagram?',
      answer1: 'Ett diagram som visar förhållandet mellan tryck och volym',
      answer2: 'Ett diagram som beskriver killars lämplighet att bli pojkvänner',
      answer3: 'Ett diagram med fyra hörn',
      correct: 2)
    GameQuestion.create!(question: 'Vem var den första människan i rymden',
      answer1: 'Neil Armstrong',
      answer2: 'Jurij Gagarin',
      answer3: 'Valentina Tresjkova',
      correct: 2)
    GameQuestion.create!(question: 'Vilket land var först med att landa ett föremål på månen?',
      answer1: 'Kina',
      answer2: 'USA',
      answer3: 'Sovjetunionen',
      correct: 3)
    GameQuestion.create!(question: 'Vem är USA:s president?',
      answer1: 'Jessica Lastow',
      answer2: 'Donald Trump',
      answer3: 'Barrack Obama',
      correct: 1)
    GameQuestion.create!(question: 'Vilken rymdkapsel använde sig Apolloprogrammet av?',
      answer1: 'Saturn IB',
      answer2: 'Saturn V',
      answer3: 'Apollo',
      correct: 3)
    GameQuestion.create!(question: 'Beräkna integralen x = [-∞,∞] ∫cosh(x)/cosh(4x)dx',
      answer1: 'Trivialt',
      answer2: 'Obviously, (π/2)*sqrt(4-2*sqrt(2))',
      answer3: 'π',
      correct: 2)
    GameQuestion.create!(question: 'Vad beskriver Drakes ekvation?',
    answer1: 'En uppskattning av hur många himlakroppar det finns i Vintergatan',
    answer2: 'En uppskattning av antalet "kontaktbara" civilisationer i Vintergatan',
    answer3: 'Anger hur sannolikt det är att en drake invaderar Jorden.',
    correct: 2)
    GameQuestion.create!(question: 'Vem är Etzel Cardeña?',
      answer1: 'En forskare vid Lunds Universitet som forskar på tankeöverföring',
      answer2: 'En matematiker som saknade näsa',
      answer3: 'En nobelpristagare i litteratur som skrev om bajs',
      correct: 1)
    GameQuestion.create!(question: 'Vad är Fermis paradox?',
      answer1: 'Motsättningen mellan den beräknade sannolikheten för utomjordiskt liv i universum och den brist på faktiska bevis att dessa existerar.',
      answer2: 'Motsättningen mellan att natthimlen är mörk och antagandet att universum är oändligt.',
      answer3: 'Ett annat namn för Tvillingparadoxen',
      correct: 1)
    GameQuestion.create!(question: 'Vem är Damir Bajs?',
      answer1: 'En person Jessica hittade på så hon kunde skriva bajs i frågesporten',
      answer2: 'En kroatisk politiker',
      answer3: 'Det Jessica kallade Damir under tiden hon var arkivarie',
      correct: 2)
    GameQuestion.create!(question: 'Vad är gunjac?',
      answer1: 'Ett instrument som även kallas bajs',
      answer2: 'Ett instrument som inte kallas bajs',
      answer3: 'En sorts frukt',
      correct: 1)
    GameQuestion.create!(question: 'Vilken form har Jorden?',
      answer1: 'Sfärisk',
      answer2: 'Klotformad',
      answer3: 'Platt',
      correct: 3)
    GameQuestion.create!(question: 'Vilka djur lät Josip Broz Tito importera till det som nu är Kroatien?',
      answer1: 'Zebror och antiloper',
      answer2: 'Älgar och vildsvin',
      answer3: 'Kaniner och marsvin',
      correct: 1)
    GameQuestion.create!(question: 'Vad är Megaspilus striolatus?',
      answer1: 'En stekelart',
      answer2: 'En koart, typ så Linnéa luktar',
      answer3: 'En sorts fluga, sånna som Linnéa attraherar för hon luktar',
      correct: 1)
    GameQuestion.create!(question: 'Vad är filstorleken på Sektionsmärket - F-sektionen - orange [PNG 500x500].png',
      answer1: '74 989 byte',
      answer2: '1 023 421 byte',
      answer3: '100 231 byte',
      correct: 1)
    GameQuestion.create!(question: 'Från vilken terminal på Arlanda går inrikesflyg?',
      answer1: '3',
      answer2: '5',
      answer3: '4',
      correct: 3)
    GameQuestion.create!(question: 'Från vilken terminal på Arlanda flyger Air France?',
      answer1: '2',
      answer2: '5',
      answer3: '6',
      correct: 1)
    GameQuestion.create!(question: 'Var på Arlanda kan man hitta butiken och doftbomben Victoria\'s Secret?',
      answer1: 'Finns inte',
      answer2: 'Sky City samt mellan F-piren och A-piren på terminal 5',
      answer3: 'Direkt efter säkerhetskontrollen på terminal 4',
      correct: 2)
    GameQuestion.create!(question: 'Vilken gate ligger längst ner på A-piren på Arlanda?',
      answer1: '27',
      answer2: '35',
      answer3: '10',
      correct: 3)
    GameQuestion.create!(question: 'Vilken var fråga 42?',
      answer1: 'Den om Jessicas miniräknare',
      answer2: 'Den om Arlanda',
      answer3: 'Den om filstorleken',
      correct: 3)
    GameQuestion.create!(question: 'När hittade Linnéa och Jessica på alla dessa 50 frågor?',
      answer1: 'Dagen innan de hade deadline',
      answer2: 'På vårterminsmötet',
      answer3: 'En vecka innan deadline för att de är skitduktiga',
      correct: 2)
    GameQuestion.create!(question: 'Vad tyckte Linnéa och Jessica om att hitta på 50 frågor?',
      answer1: 'Så jävla jobbigt. Varför 50 stycken???',
      answer2: 'Easy',
      answer3: 'Helt ok',
      correct: 2)
  end
end

