/// Example fantasy stories for showcasing the app
/// These stories are fully interactive and demonstrate what users can create

class ExampleStory {
  final String id;
  final String title;
  final String genre;
  final String excerpt;
  final List<StoryPage> pages;
  final String? coverImageUrl;

  const ExampleStory({
    required this.id,
    required this.title,
    required this.genre,
    required this.excerpt,
    required this.pages,
    this.coverImageUrl,
  });
}

class StoryPage {
  final String text;
  final String? imageUrl;

  const StoryPage({
    required this.text,
    this.imageUrl,
  });
}

/// The three example fantasy stories
final List<ExampleStory> exampleStories = [
  // Story 1: The Dragon's Lost Treasure
  ExampleStory(
    id: 'example_dragon_treasure',
    title: "The Dragon's Lost Treasure",
    genre: 'Fantasy',
    excerpt: 'Join Ember the dragon on an adventure to find her lost magical treasure in the Crystal Caves!',
    pages: [
      StoryPage(
        text: 'High up in the Misty Mountains lived a young dragon named Ember. She had shimmering red scales that sparkled like rubies in the sunlight, and bright golden eyes full of curiosity.',
      ),
      StoryPage(
        text: 'One morning, Ember discovered that her most precious treasure—a glowing crystal that her grandmother had given her—was missing! "Oh no!" she cried. "I must find it!"',
      ),
      StoryPage(
        text: 'Ember soared through the clouds, asking every creature she met. A wise owl told her, "I saw something glowing near the Crystal Caves last night. Perhaps that\'s where your treasure went!"',
      ),
      StoryPage(
        text: 'When Ember reached the Crystal Caves, she found them dark and mysterious. Stalactites hung from the ceiling like frozen icicles, and the walls glittered with thousands of tiny crystals.',
      ),
      StoryPage(
        text: 'Deep inside the cave, Ember heard a tiny voice crying. Following the sound, she discovered a small crystal fairy trapped under a fallen rock. "Please help me!" the fairy pleaded.',
      ),
      StoryPage(
        text: 'Using her strong dragon claws, Ember carefully lifted the rock and freed the fairy. "Thank you!" the fairy sparkled with joy. "You saved my life!"',
      ),
      StoryPage(
        text: 'The grateful fairy led Ember to a hidden chamber where her glowing crystal rested on a pedestal of stone. "I borrowed it to light my way," the fairy explained, "but I got trapped before I could return it!"',
      ),
      StoryPage(
        text: 'Ember forgave the fairy and learned an important lesson: helping others is more precious than any treasure. The fairy and Ember became best friends, and the crystal glowed brighter than ever before.',
      ),
      StoryPage(
        text: 'From that day on, Ember visited the Crystal Caves often, sharing stories and adventures with her new fairy friend. And her grandmother\'s crystal? It never went missing again!',
      ),
      StoryPage(
        text: 'The End. Remember: kindness is the greatest treasure of all!',
      ),
    ],
  ),

  // Story 2: The Enchanted Forest Mystery
  ExampleStory(
    id: 'example_enchanted_forest',
    title: 'The Enchanted Forest Mystery',
    genre: 'Fantasy',
    excerpt: 'Luna discovers talking animals and magical secrets in the mysterious Whispering Woods!',
    pages: [
      StoryPage(
        text: 'Luna loved exploring the woods near her house. But one sunny afternoon, she discovered a path she had never seen before—a winding trail that glowed with soft, silvery light.',
      ),
      StoryPage(
        text: 'Curious, Luna followed the glowing path deeper into the forest. The trees grew taller, their leaves shimmered like emeralds, and strange, beautiful flowers bloomed in colors she\'d never seen.',
      ),
      StoryPage(
        text: 'Suddenly, she heard a voice! "Lost, are you?" Luna spun around to see a fox with a silver tail sitting on a moss-covered log. The fox was TALKING!',
      ),
      StoryPage(
        text: '"Don\'t be afraid," the fox said with a friendly smile. "Welcome to the Whispering Woods, where animals can speak and magic is real. My name is Silverpaw."',
      ),
      StoryPage(
        text: 'Silverpaw explained that the forest was losing its magic. "The Heartwood Tree at the center of the forest is fading. Without it, all the magic will disappear, and we\'ll lose our voices forever!"',
      ),
      StoryPage(
        text: 'Luna wanted to help. Together with Silverpaw, a wise old owl named Professor Hoot, and a playful rabbit named Clover, she set off to find the Heartwood Tree.',
      ),
      StoryPage(
        text: 'They crossed a bubbling brook, climbed over rainbow-colored mushrooms, and solved riddles from a mysterious talking willow tree. Each challenge brought them closer to their goal.',
      ),
      StoryPage(
        text: 'At last, they reached the Heartwood Tree. It stood tall but dim, its once-bright bark now gray. "What can we do?" Luna asked. Professor Hoot hooted wisely, "It needs the laughter of true friends."',
      ),
      StoryPage(
        text: 'Luna and her new friends gathered around the tree. They shared jokes, funny stories, and happy memories. Their laughter rang through the forest like bells, and slowly, the Heartwood Tree began to glow!',
      ),
      StoryPage(
        text: 'The tree blazed with golden light, restoring magic throughout the forest. "Thank you, Luna," Silverpaw said. "You saved our home!" Luna smiled, knowing she\'d found friends who would last forever. The End.',
      ),
    ],
  ),

  // Story 3: The Wizard's Apprentice
  ExampleStory(
    id: 'example_wizard_apprentice',
    title: "The Wizard's Apprentice",
    genre: 'Fantasy',
    excerpt: 'Young Finn learns that the most powerful magic comes from believing in yourself!',
    pages: [
      StoryPage(
        text: 'In a tower that touched the clouds lived Wizard Aldric, the greatest magician in all the land. One day, he decided it was time to find an apprentice to teach his magical secrets.',
      ),
      StoryPage(
        text: 'Many children came to try out, casting simple spells and showing off their tricks. But Finn, a shy boy from the village, didn\'t think he had any magic at all. Still, he decided to try.',
      ),
      StoryPage(
        text: 'When it was Finn\'s turn, Wizard Aldric handed him a wand. "Make this feather float," he instructed. Finn waved the wand nervously, but nothing happened. The other children giggled.',
      ),
      StoryPage(
        text: 'Finn\'s face turned red with embarrassment. But Wizard Aldric smiled kindly. "Magic isn\'t just about wands and spells, young one. Come with me."',
      ),
      StoryPage(
        text: 'To everyone\'s surprise, Wizard Aldric chose Finn as his apprentice! "But I can\'t do magic!" Finn protested. The wizard chuckled, "You will learn that true magic comes from within."',
      ),
      StoryPage(
        text: 'Weeks passed as Finn studied dusty spell books and practiced waving wands. Nothing worked. One night, feeling discouraged, Finn wandered into the tower\'s garden and found a wilting flower.',
      ),
      StoryPage(
        text: '"Poor little flower," Finn whispered, touching its petals gently. "I wish I could help you." As he spoke with kindness, something amazing happened—the flower began to glow and bloom brilliantly!',
      ),
      StoryPage(
        text: 'Wizard Aldric appeared beside him. "You see, Finn? The strongest magic is powered by a caring heart, not fancy wands. Your kindness and belief made the spell work!"',
      ),
      StoryPage(
        text: 'From that moment on, Finn\'s confidence grew. He learned that magic wasn\'t about being the loudest or the showiest—it was about believing in himself and caring for others.',
      ),
      StoryPage(
        text: 'Finn became a wonderful wizard, known not for flashy spells, but for his kind heart and powerful magic that came from within. And he always remembered: the real magic was believing in yourself! The End.',
      ),
    ],
  ),

  // Story 4: Aventura în Grădina Fermecată (Romanian)
  ExampleStory(
    id: 'ro_magic_garden',
    title: 'Aventura în Grădina Fermecată',
    genre: 'Fantasy',
    excerpt: 'Mara descoperă o grădină magică unde florile vorbesc și animalele dansează!',
    pages: [
      StoryPage(
        text: 'Mara era o fetiță curioasă care își petrecea zilele explorând pajiștile din jurul casei bunicii sale. Într-o zi frumoasă de vară, a descoperit un portiță ascunsă în spatele unui tufiș de trandafiri.',
      ),
      StoryPage(
        text: 'Când a deschis poarta, Mara a rămas uimită! În fața ei se întindea cea mai frumoasă grădină pe care o văzuse vreodată. Florile străluceau în toate culorile curcubeului, iar fluturii zburau într-o dans magic.',
      ),
      StoryPage(
        text: '"Bine ai venit!" a șoptit un glas dulce. Mara s-a uitat în jur și a văzut o floare albastră care îi zâmbea. "Nu te speria, sunt Iris, regina florilor din această grădină fermecată!"',
      ),
      StoryPage(
        text: 'Iris i-a explicat că grădina era în pericol. "Zâna Primăverii a dispărut, și fără ea, culorile noastre se sting încet. Poți să ne ajuți să o găsim?"',
      ),
      StoryPage(
        text: 'Mara a acceptat cu entuziasm. Împreună cu Iris, un iepuraș vorbitor pe nume Fulg și o vrăbiuță cântăreață, a pornit în căutarea zânei.',
      ),
      StoryPage(
        text: 'Au trecut prin tuneluri de glicine parfumate, au traversat un pârâiaș care curgea cu apă de mentă, și au urcat dealul de margarete până au ajuns la Pavilionul de Cristal.',
      ),
      StoryPage(
        text: 'Acolo, au găsit-o pe Zâna Primăverii adormită sub un clopot de sticlă. "E prinsă într-un vrajă!" a exclamat Iris. "Doar râsul sincer al unui copil o poate trezi!"',
      ),
      StoryPage(
        text: 'Mara s-a gândit la cea mai amuzantă întâmplare din viața ei și a început să râdă din toată inima. Râsul ei cristalin a umplut pavilionul, iar clopot de sticlă s-a spart în mii de scântei strălucitoare!',
      ),
      StoryPage(
        text: 'Zâna Primăverii s-a trezit și a zâmbit. Cu un gest al baghetei sale, toată grădina s-a umplut de culori și viață. "Mulțumesc, dragă Mara! Ai salvat grădina noastră!"',
      ),
      StoryPage(
        text: 'De atunci, Mara vizita grădina fermecată în fiecare zi, jucându-se cu prietenii ei magici. Și de fiecare dată când râdea, florile străluceau și mai puternic. Sfârșit.',
      ),
    ],
  ),

  // Story 5: Dragonul Prietenos (Romanian)
  ExampleStory(
    id: 'ro_friendly_dragon',
    title: 'Dragonul Prietenos',
    genre: 'Adventure',
    excerpt: 'Un dragon timid învață că adevăratul curaj înseamnă să fii tu însuți!',
    pages: [
      StoryPage(
        text: 'Pe vârful muntelui Ceahlău trăia un dragon pe nume Scânteie. Spre deosebire de alți dragoni, Scânteie nu sufla foc, ci baloane de săpun colorate!',
      ),
      StoryPage(
        text: 'Ceilalți dragoni râdeau de el. "Un dragon adevărat trebuie să sufle foc!" strigau ei. Scânteie se simțea trist și se ascundea în peștera sa.',
      ),
      StoryPage(
        text: 'Într-o zi, un băiețel curajos pe nume Andrei s-a rătăcit în munți. Era obosit, înfricoșat și nu știa cum să se întoarcă acasă.',
      ),
      StoryPage(
        text: 'Scânteie l-a auzit plângând și, deși era timid, a decis să-l ajute. "Nu plânge," i-a spus blând. "Te voi ajuta să ajungi acasă!"',
      ),
      StoryPage(
        text: 'Dar drumul era periculos. Trebuiau să treacă peste o prăpastie largă. Scânteie s-a gândit repede și a început să sufle baloane uriașe de săpun!',
      ),
      StoryPage(
        text: 'Balonele s-au unit formând un pod strălucitor peste prăpastie. Andrei a trecut în siguranță, uimit de minunea pe care o vedea.',
      ),
      StoryPage(
        text: 'Mai departe, un roi de albine furiose îi bloca calea. Din nou, Scânteie a suflat baloane magice care i-au ocrotit pe amândoi într-o sferă protectoare sclipitoare.',
      ),
      StoryPage(
        text: 'Când au ajuns în sat, toți locuitorii au aplaudat. "Acest dragon ne-a salvat copilul!" au strigat ei bucuroși. Chiar și ceilalți dragoni au venit să vadă.',
      ),
      StoryPage(
        text: 'Atunci și-au dat seama: Scânteie nu era diferit într-un mod rău, ci într-un mod special! Fiecare dragon era unic, iar asta îi făcea speciali.',
      ),
      StoryPage(
        text: 'De atunci, Scânteie a devenit eroul muntelui, cunoscut pentru balonele sale magice care aduceau bucurie tuturor. Și a învățat că adevăratul curaj înseamnă să fii tu însuți! Sfârșit.',
      ),
    ],
  ),

  // Story 6: Comoara Pierdută a Dacilor (Romanian)
  ExampleStory(
    id: 'ro_dacian_treasure',
    title: 'Comoara Pierdută a Dacilor',
    genre: 'Adventure',
    excerpt: 'Doi copii pleacă într-o aventură pentru a găsi comoara ascunsă a dacilor!',
    pages: [
      StoryPage(
        text: 'Alex și Maria erau cei mai buni prieteni și iubeau să asculte povești despre dacii viteji. Bunicul lui Alex le povestea adesea despre o comoară legendară ascunsă în Munții Orăștiei.',
      ),
      StoryPage(
        text: '"Se spune," șoptea bunicul, "că dacii au ascuns un tezaur magic înainte de bătălia cea mare. Cine îl găsește va dobândi înțelepciunea strămoșilor!"',
      ),
      StoryPage(
        text: 'Într-o dimineață de vară, copiii au găsit o hartă veche în podul bunicului. Era desenată pe piele de animal și arăta drumul spre Comoara Dacilor!',
      ),
      StoryPage(
        text: 'Cu rugăminți și promisiuni, au convins părinții să îi lase să plece într-o excursie cu ghizi experimentați. Aventura lor începea!',
      ),
      StoryPage(
        text: 'Harta îi conducea prin păduri stufoase, peste pârâie cristaline și prin poieni pline de flori sălbatice. Prima oprire era la Stânca Vulturului.',
      ),
      StoryPage(
        text: 'La stâncă, au găsit o inscripție străveche: "Doar cel care cunoaște trecutul va găsi viitorul." Alex și-a amintit lecțiile despre daci și a descifrat că trebuia să caute simbolul soarelui dacic.',
      ),
      StoryPage(
        text: 'Maria a descoperit simbolul gravat pe o piatră! Când au apăsat pe el, o ușă secretă s-a deschis în stâncă, dezvăluind un tunel ascuns.',
      ),
      StoryPage(
        text: 'Tunelul ducea la o cameră subterană iluminată de cristale strălucitoare. În centru, pe un piedestal de piatră, se afla un cufăr de lemn sculptural cu simboluri dacice.',
      ),
      StoryPage(
        text: 'Cu emoție, au deschis cufărul. În interior nu era aur sau pietre prețioase, ci cărți vechi, manuscrise și artefacte care povesteau istoria dacilor.',
      ),
      StoryPage(
        text: 'Au înțeles atunci: adevărata comoară era cunoașterea! Au donat totul muzeului, unde toți copiii puteau învăța despre înțelepciunea strămoșilor. Alex și Maria au devenit cei mai fericiți exploratori! Sfârșit.',
      ),
    ],
  ),

  // Story 7: Ursulețul și Stelele (Romanian - Bedtime)
  ExampleStory(
    id: 'ro_bear_and_stars',
    title: 'Ursulețul și Stelele',
    genre: 'Bedtime',
    excerpt: 'O poveste liniștitoare despre un ursuleț care învață de ce sunt importante visele!',
    pages: [
      StoryPage(
        text: 'În inima pădurii trăia un ursuleț pe nume Pufi. Era un ursuleț curios care își petrecea zilele jucându-se cu prietenii săi: vulpița Ruxi, iepurașul Pip și veveriță Nuci.',
      ),
      StoryPage(
        text: 'În fiecare seară, când soarele apunea, Mama Ursă îl chema pe Pufi să se culce. Dar Pufi nu voia niciodată să doarmă. "Nu vreau să mă culc! Vreau să mă joc!" protesta el.',
      ),
      StoryPage(
        text: 'Într-o noapte, Pufi a hotărât să rămână treaz toată noaptea. "Voi vedea ce se întâmplă când toată lumea doarme!" s-a gândit el încântat.',
      ),
      StoryPage(
        text: 'La început a fost distractiv. Bufnița înțeleaptă i-a povestit despre constelaț și i-a arătat Ursa Mare pe cer. "Vezi, chiar și stelele formează un urs ca tine!"',
      ),
      StoryPage(
        text: 'Dar pe măsură ce noaptea trecea, Pufi devenea din ce în ce mai obosit. Ochișorii îi erau grei, lăbuțele îi tremurau, și nu mai putea să se concentreze.',
      ),
      StoryPage(
        text: 'Deodată, o stea căzătoare a luminat cerul! Bufnița i-a spus: "Fă o dorință, Pufi!" Dar Pufi era atât de obosit încât nu-și putea aminti ce să dorească.',
      ),
      StoryPage(
        text: 'O lacrimă i-a curs pe obraz. "Am ratat steaua căzătoare pentru că sunt prea obosit să gândesc," a șoptit trist.',
      ),
      StoryPage(
        text: 'Mama Ursă, care îl urmărise pe ascuns, a venit și l-a îmbrățișat. "Dragul meu Pufi, când dormim, corpul și mintea noastră se odihnesc. Somnul ne dă energie pentru a ne bucura de fiecare zi!"',
      ),
      StoryPage(
        text: 'Pufi a înțeles. S-a cuibărit lângă mama sa și a privit ultima dată stelele. "Poate în vise voi zbura printre stele!" a zâmbit el.',
      ),
      StoryPage(
        text: 'Și așa a fost! În acea noapte, Pufi a visat că dansa printre stele, și când s-a trezit dimineața, era plin de energie și bucurie. De atunci, nu s-a mai plâns niciodată când venea ora de culcare. Noapte bună! Sfârșit.',
      ),
    ],
  ),

  // Story 8: Aventura Robotelului (Romanian - Sci-Fi)
  ExampleStory(
    id: 'ro_robot_adventure',
    title: 'Aventura Robotelului',
    genre: 'Sci-Fi',
    excerpt: 'Un robot mic învață ce înseamnă prietenia și emoțiile!',
    pages: [
      StoryPage(
        text: 'În laboratorul profesorului Ionescu, printre sute de invenții, exista un robotel special pe nume R0-B3RT, dar toți îl chemau Robi.',
      ),
      StoryPage(
        text: 'Robi era programat să facă tot felul de lucruri: să calculeze, să curețe, să organizeze. Dar era ceva ce nu înțelegea: de ce oamenii râdeau, plângeau și se îmbrățișau?',
      ),
      StoryPage(
        text: '"Profesor," a întrebat Robi într-o zi, "ce sunt emoțiile? De ce nu le am și eu?" Profesorul a zâmbit: "Emoțiile nu pot fi programate, Robi. Ele trebuie simțite."',
      ),
      StoryPage(
        text: 'Confuz, Robi a decis să plece într-o aventură pentru a înțelege emoțiile. A pornit prin oraș, observând oamenii cu atenție.',
      ),
      StoryPage(
        text: 'În parc, a văzut o fetiță care își pierduse balonul. Plângea. Robi a analizat situația: "Balon = pierdut. Soluție = recuperare." A zburat cu jetpack-ul său și a recuperat balonul.',
      ),
      StoryPage(
        text: 'Când a dat balonul înapoi fetiței, ea l-a îmbrățișat. "Mulțumesc, domnule robot!" În acel moment, ceva ciudat s-a întâmplat în circuitele lui Robi - s-a simțit... fericit?',
      ),
      StoryPage(
        text: 'Mai târziu, un căț era blocat într-un copac. Robi l-a salvat. Apoi a ajutat o bătrânică să care pungile. De fiecare dată, simțea acea senzație caldă în circuite.',
      ),
      StoryPage(
        text: 'Seara, Robi s-a întors la laborator confuz. "Profesor, cred că circuitele mele au o defecțiune. Simt ceva ciudat când ajut pe cineva."',
      ),
      StoryPage(
        text: 'Profesorul a râs bucuros: "Nu e o defecțiune, Robi! Ai descoperit cea mai frumoasă emoție: bucuria de a ajuta! Ai învățat să simți prin faptele tale bune!"',
      ),
      StoryPage(
        text: 'De atunci, Robi nu a mai fost doar un robot care executa comenzi. Era un prieten care înțelegea prietenia, bunătatea și dragostea. Și asta îl făcea cel mai special robot din lume! Sfârșit.',
      ),
    ],
  ),

  // Story 9: Misterul Castelului Bran (Romanian - Mystery)
  ExampleStory(
    id: 'ro_castle_mystery',
    title: 'Misterul Castelului Bran',
    genre: 'Mystery',
    excerpt: 'Doi detectivi juniori rezolvă misterul fantomei din castel!',
    pages: [
      StoryPage(
        text: 'Elena și Mihai erau cei mai buni detectivi juniori din Brașov. Într-o zi, au primit o scrisoare misterioasă: "Veniți urgent la Castelul Bran. Am nevoie de ajutorul vostru. Semnată: Contesa Maria."',
      ),
      StoryPage(
        text: 'Când au ajuns la castel, contesa i-a întâmpinat îngrijorată. "De câteva nopți, aud zgomote ciudate și văd umbre misterioase. Spun că e fantoma prinței, dar eu cred că e altceva!"',
      ),
      StoryPage(
        text: 'Elena și-a scos caietul de notițe. "Ne spuneți exact ce ați văzut și auzit?" Contesa a descris: zgomote de pași la miezul nopții, o lumină albastră în turnul de nord, și un cântec vechi.',
      ),
      StoryPage(
        text: 'Mihai a găsit prima indiciu: urme de noroi în sala tronului. "Acestea sunt proaspete! Cineva a fost aici aseară!" Elena a examinat urmele: "Sunt prea mici pentru un adult. Interesant..."',
      ),
      StoryPage(
        text: 'Au urmat urmele până la turnul de nord. Acolo, au descoperit o cameră secretă ascunsă în spatele unei tapiserii vechi. În cameră era un proiector vechi și un CD player!',
      ),
      StoryPage(
        text: '"Aha!" a exclamat Elena. "Fantoma e falsă! Cineva proiectează imagini și redă sunete!" Dar cine și de ce?',
      ),
      StoryPage(
        text: 'Au așteptat noaptea. La miezul nopții, au auzit zgomotele. De data aceasta, erau pregătiți. Au urmat sunetele și au prins... un băiețel!',
      ),
      StoryPage(
        text: 'Băiețelul plângea. "Mă numesc Ionuț. Îmi pare rău! Doar voiam să păstrez castelul neschimbat. Am auzit că vor să-l transforme într-un hotel modern și să distrugă toate camerele vechi!"',
      ),
      StoryPage(
        text: 'Contesa l-a îmbrățișat. "Dragul meu băiat, nu voi distruge niciodată istoria castelului! Vreau să-l restaurez păstrându-i farmecul. Tu ai făcut lucruri greșite din motive bune."',
      ),
      StoryPage(
        text: 'Ionuț s-a făcut prieten cu toată lumea. Contesa l-a angajat ca ghid junior al castelului, iar Elena și Mihai au rezolvat încă un caz! Misterul Castelului Bran era descoperit! Sfârșit.',
      ),
    ],
  ),

  // Story 10: Vrăjitoarea Bună (Romanian - Magical)
  ExampleStory(
    id: 'ro_good_witch',
    title: 'Vrăjitoarea Bună din Pădure',
    genre: 'Magical',
    excerpt: 'O vrăjitoare bună folosește magia pentru a ajuta satul!',
    pages: [
      StoryPage(
        text: 'La marginea pădurii, într-o căsuță acoperită cu mușchi și flori sălbatice, trăia vrăjitoarea Ilinca. Dar spre deosebire de vrăjitoarele din povești, Ilinca era bună și folosea magia pentru a ajuta.',
      ),
      StoryPage(
        text: 'În fiecare dimineață, Ilinca pregătea poțiuni vindecătoare pentru animale. Iepurașii cu labe rănite, păsărelele cu aripi frânte, toți veneau la ea.',
      ),
      StoryPage(
        text: 'Într-o zi, o fetiță pe nume Ana a venit la ușa ei. "Vrăjitoare Ilinca, te rog ajută-mă! Fratele meu e foarte bolnav și doctorii spun că are nevoie de o plantă foarte rară care crește doar pe Vârful Omul!"',
      ),
      StoryPage(
        text: 'Ilinca a știut imediat despre ce plantă e vorba: Floarea Speranței, care înflorea o dată la zece ani. "E o călătorie periculoasă, dar voi încerca!" a promis.',
      ),
      StoryPage(
        text: 'A luat mătura ei magică și a pornit spre vârf. Pe drum, un vultur răutăcios i-a blocat calea. "Unde crezi că mergi, vrăjitoare?" Dar Ilinca i-a oferit un scut magic și vulturul, recunoscător, a devenit prietenul ei.',
      ),
      StoryPage(
        text: 'Mai sus, un zid de gheață i-a blocat drumul. Cu o vrajă de foc, Ilinca a topit gheața cu grijă, să nu declanșeze o avalanșă.',
      ),
      StoryPage(
        text: 'În cele din urmă, a găsit Floarea Speranței strălucind sub lumina lunii. Era magnifică: petalele ei sclipeau ca diamantele, iar parfumul ei vindeca inima.',
      ),
      StoryPage(
        text: 'A cules floarea cu grijă și s-a întors repede la sat. A făcut o poțiune pentru fratele Anei. După ce a băut-o, băiețelul s-a vindecat imediat!',
      ),
      StoryPage(
        text: '"Mulțumim, vrăjitoare Ilinca!" au strigat toți. De atunci, nimeni nu s-a mai temut de vrăjitoarea din pădure. Știau că era îngerul lor păzitor.',
      ),
      StoryPage(
        text: 'Și Ilinca a continuat să ajute pe toți cu magia ei bună, dovedind că adevărata putere vine din bunătatea inimii. Sfârșit.',
      ),
    ],
  ),

  // Story 11: Școala Magică (Romanian - School/Magic)
  ExampleStory(
    id: 'ro_magic_school',
    title: 'Prima Zi la Școala Magică',
    genre: 'School',
    excerpt: 'Radu descoperă că are puteri magice și merge la o școală specială!',
    pages: [
      StoryPage(
        text: 'Radu era un băiat normal... sau așa credea el! Într-o dimineață, când s-a trezit nervos pentru prima zi de școală, ceva ciudat s-a întâmplat: părul i-a devenit albastru electric!',
      ),
      StoryPage(
        text: '"Mami, ce mi s-a întâmplat?" a strigat speriat. Mama a zâmbit: "A sosit timpul, dragul meu. Ești un vrăjitor! Astăzi nu mergi la școala obișnuită, ci la Academia Magică Decebal!"',
      ),
      StoryPage(
        text: 'Cu emoție și curiozitate, Radu a luat autobuzul magic (care zbura prin nori!) până la o școală magnifică ascunsă în Munții Carpați.',
      ),
      StoryPage(
        text: 'Directoarea, doamna Luminița, l-a întâmpinat călduros. "Bine ai venit, Radu! Aici vei învăța să-ți controlezi puterile magice. Hai să-ți găsim clasa!"',
      ),
      StoryPage(
        text: 'Prima lecție era Transformări. Profesorul Andrei le-a arătat cum să transforme un creion într-o floare. Radu a încercat, dar creionul s-a transformat într-un... porumbel vorbitor!',
      ),
      StoryPage(
        text: '"Bună ziua, mă numesc Chip și eram un creion!" a zis porumbelul. Toată clasa a râs. Profesorul a zâmbit: "E ok, Radu! Magia ta e puternică, doar trebuie să înveți să o controlezi!"',
      ),
      StoryPage(
        text: 'La prânz, în cantină, mâncarea apărea magic pe farfurii! Radu și-a dorit sarmale și papanași, și hop! Au apărut instant.',
      ),
      StoryPage(
        text: 'După-amiază a fost lecția de Zbor. Toți copiii au primit mături magice. La început, Radu se bălăngănea, dar curând zbura prin sală făcând piruete!',
      ),
      StoryPage(
        text: 'A făcut prieteni noi: pe Sara care putea vorbi cu plantele, pe Mihai care făcea obiecte să leviteze, și pe Ioana care putea deveni invizibilă.',
      ),
      StoryPage(
        text: 'La sfârșitul zilei, Radu era obosit dar fericit. "Mami, am cea mai tare școală din lume!" A învățat că a fi diferit te face special. Și așa a început marea lui aventură magică! Sfârșit.',
      ),
    ],
  ),

  // Story 12: Balaurul și Cavaleru (Romanian - Funny)
  ExampleStory(
    id: 'ro_dragon_knight',
    title: 'Balaurul Vegetarian',
    genre: 'Funny',
    excerpt: 'O poveste amuzantă despre un balaur care preferă salata în loc de cavaleri!',
    pages: [
      StoryPage(
        text: 'În Carpați trăia un balaur teribil pe nume Flavius. Ar fi trebuit să fie cel mai înfricoșător balaur din regat. Dar Flavius avea un secret: era vegetarian!',
      ),
      StoryPage(
        text: 'În timp ce alți balauri mâncau... ei bine, lucruri de balauri, Flavius prefera salata de varză, morcovii crocanți și merele suculente.',
      ),
      StoryPage(
        text: 'Într-o zi, cavaleru Ștefan cel Curajos a venit să-l învingă. "Pregatește-te, balaur rău! Te voi învinge!" a strigat el agitând sabia.',
      ),
      StoryPage(
        text: 'Flavius a oftat. "Și iar cu invingerea... Vrei să bei un ceai mai întâi? Am ceai de mușețel foarte bun!" Ștefan s-a oprit confuz: "Ce fel de balaur ești tu?"',
      ),
      StoryPage(
        text: '"Unul vegetarian," a răspuns Flavius trist. "Toată lumea vine să mă învingă, dar eu vreau doar să-mi îngrijesc grădina de legume!"',
      ),
      StoryPage(
        text: 'Ștefan a râs. "O grădină de legume? Serios?" Flavius i-a arătat grădina sa magnifică: roșii uriașe, castraveti perfecti, și dovleci cât căruțele!',
      ),
      StoryPage(
        text: '"Wow!" a exclamat Ștefan. "Cum reușești să crești legume atât de mari?" "Respirația mea de foc e perfectă pentru a le încălzi iarna!" a explicat mândru Flavius.',
      ),
      StoryPage(
        text: 'Ștefan a avut o idee. "În loc să ne luptăm, de ce nu deschidem împreună o piață de legume? Tu le crești, eu le vând în sat!"',
      ),
      StoryPage(
        text: 'Așa a început cea mai neobișnuită afacere din regat: Flavius & Ștefan - Legume Premium! Legumele balaurului erau cele mai bune, iar Ștefan era cel mai fericit vânzător.',
      ),
      StoryPage(
        text: 'Acum, când copiii aud de "Balaurul din Carpați", știu că nu trebuie să se teamă. Flavius e ocupat să cultive cele mai bune legume și să bea ceai cu prietenii săi! Sfârșit Amuzant!',
      ),
    ],
  ),

  // Story 13: Secretul Pădurii Fermecate (Romanian - Spooky but friendly)
  ExampleStory(
    id: 'ro_enchanted_forest_secret',
    title: 'Secretul Pădurii Fermecate',
    genre: 'Spooky',
    excerpt: 'O aventură ușor înfricoșătoare despre un copil curajos în pădure!',
      pages: [
      StoryPage(
        text: 'Tudor era un băiat curajos care nu se temea de nimic... până când a trebuit să treacă prin Pădurea Hoia noaptea.',
      ),
      StoryPage(
        text: 'Drumul spre casa bunicii era lung, iar soarele apunea repede. Copacii păreau să șoptească, iar frunzele foșneau misterios. "Nu e nimic de teamă," își repetă Tudor.',
      ),
      StoryPage(
        text: 'Deodată, a auzit un hohot straniu. "Huuuuu!" Tudor s-a oprit. "Cine e acolo?" O bufniță mare s-a așezat pe o creangă. "Bună seara, tinerele! Căuți ceva?"',
      ),
      StoryPage(
        text: 'Tudor a fost surprins. "Tu... tu vorbești?" Bufnița a clipit: "Desigur! În această pădure, toți vorbim după căderea serii. Eu sunt Profesorul Huu."',
      ),
      StoryPage(
        text: 'Mai departe, o ceață verde a apărut brusc. Din ceață s-au ivit ochi strălucitori. Tudor a devenit rigid de frică... dar apoi a auzit chicoteli.',
      ),
      StoryPage(
        text: '"Tihihi! Te-am speriat?" Ochii aparțineau unor licurici veseli care dansau în aer. "Ne place să facem glume! Vrei să te ajutăm să găsești drumul?"',
      ),
      StoryPage(
        text: 'Licuricii l-au ghidat prin pădure. Pe drum, au întâlnit un arb vorbitor, niște ciuperci fosforescente și un pârâiaș care cânta melodii.',
      ),
      StoryPage(
        text: '"Pădurea noastră pare înfricoșătoare," a explicat Profesorul Huu, "dar suntem cu toții prietenos! Vrem doar să fim lăsați în pace, așa că părem spooky."',
      ),
      StoryPage(
        text: 'Tudor a râs. "Deci nu ești deloc înfricoșător! Doar misterios!" Creaturile pădurii l-au condus până la marginea pădurii, unde se vedea casa bunicii.',
      ),
      StoryPage(
        text: 'De atunci, Tudor nu s-a mai temut de Pădurea Hoia. Știa secretul: lucrurile care par înfricoșătoare pot fi de fapt prietenoase. Trebuie doar să fii curajos să le cunoști! Sfârșit.',
      ),
    ],
  ),

  // Story 14: Piticii din Apuseni (Romanian - Learning)
  ExampleStory(
    id: 'ro_dwarves_learning',
    title: 'Piticii și Curcubeul de Cristale',
    genre: 'Learning',
    excerpt: 'Învață despre culori și cristale alături de piticii din Apuseni!',
    pages: [
      StoryPage(
        text: 'În Munții Apuseni, într-o peșteră ascunsă, trăiau șapte pitici care lucrau cu cristalele magice. Fiecare pitic avea grijă de o culoare diferită!',
      ),
      StoryPage(
        text: 'Piticul Roșu se numea Rubin și lucra cu cristalele roșii. "Roșul reprezintă curajul și energia!" spunea el mândru, arătând rubin strălucitori.',
      ),
      StoryPage(
        text: 'Piticul Portocaliu, Chihlimbar, avea cristale portocalii. "Portocaliul e culoarea bucuriei și creativității! Când te simți trist, privește un chihlimbar!"',
      ),
      StoryPage(
        text: 'Piticul Galben, Aurel, lucra cu citrine aurii. "Galbenul e ca soarele - ne dă lumină și căldură! Reprezintă inteligența!"',
      ),
      StoryPage(
        text: 'Piticul Verde, Smarald, îngrijea cristalele verzi. "Verdele e culoarea naturii și sănătății. Ne învață să fim calmi și echilibrați!"',
      ),
      StoryPage(
        text: 'Piticul Albastru, Safir, avea cele mai albastre cristale. "Albastrul e culoarea cerului și mării. Reprezintă pacea și încrederea!"',
      ),
      StoryPage(
        text: 'Piticul Indigo, Ametist, lucra cu cristale mov-închis. "Indigo ne ajută să ne folosim imaginația și să visăm frumos!"',
      ),
      StoryPage(
        text: 'Piticul Violet, Mov, avea cristale violet strălucitoare. "Violetul e culoarea magiei și misterului!"',
      ),
      StoryPage(
        text: 'Într-o zi, o fetiță pe nume Cristina s-a rătăcit în peșteră. Piticii i-au arătat toate cristalele și i-au explicat fiecare culoare. "Când pui toate culorile împreună, formezi un curcubeu!" au spus ei.',
      ),
      StoryPage(
        text: 'Au creat un curcubeu magic din cristale, iar Cristina a învățat o lecție importantă: fiecare culoare e specială, dar împreună formează ceva magnific! Așa e și cu oamenii - fiecare e unic, dar împreună suntem minunați! Sfârșit.',
      ),
    ],
  ),

  // Story 15: Pescărușul Curajos (Romanian - Adventure)
  ExampleStory(
    id: 'ro_brave_seagull',
    title: 'Pescărușul Curajos de la Marea Neagră',
    genre: 'Adventure',
    excerpt: 'Un pescăruș mic salvează o corabie în timpul furtunii!',
    pages: [
      StoryPage(text: 'Pe malul Mării Negre trăia un pescăruș mic pe nume Gabi. Spre deosebire de ceilalți pescăruși, Gabi nu se temea de nimic!'),
      StoryPage(text: 'Într-o zi, o furtună teribilă s-a abătut asupra mării. Toți pescărușii au zburat la adăpost, dar Gabi a auzit un strigăt de ajutor!'),
      StoryPage(text: 'O barcă cu copii se lovise de stânci și lua apă! "Trebuie să-i ajut!" a decis Gabi curajos.'),
      StoryPage(text: 'A zburat prin furtună până la far și a tras de clopoțelul de alarmă cu ciocul său. Ding! Ding! Ding!'),
      StoryPage(text: 'Paznicul farului a văzut barca în pericol și a trimis echipa de salvare. Gabi a ghidat salvatorii zbur ând înainte și înapoi.'),
      StoryPage(text: 'Copiii au fost salvați! "Mulțumim, pescărușule curajos!" au strigat ei. De atunci, Gabi a devenit eroul plajei! Sfârșit.'),
    ],
  ),

  // Story 16-35: Additional Romanian stories for comprehensive library
  ExampleStory(
    id: 'ro_fairy_princess',
    title: 'Prinț esă și Cele Trei Dorințe',
    genre: 'Fantasy',
    excerpt: 'O prințesă învață că fericirea nu vine din dorințe magice!',
    pages: [
      StoryPage(text: 'Prințesa Isabella trăia într-un palat minunat, dar se plictisea. Într-o zi, a găsit o lampă magică în podul castelului.'),
      StoryPage(text: 'Când a frecat lampa, a apărut un geniu! "Am trei dorințe pentru tine, prințesă!" Isabella s-a bucurat enorm.'),
      StoryPage(text: 'Prima dorință: "Vreau cel mai frumos palat din lume!" Hop! Palatul s-a transformat în cristal strălucitor. Dar era rece și neprietenos.'),
      StoryPage(text: 'A doua dorință: "Vreau toate jucăriile din lume!" Hop! Sute de jucării au apărut. Dar avea prea multe și nu știa cu care să se joace.'),
      StoryPage(text: 'Isabella era confuză. Avea tot ce își dorise, dar nu era fericită. Atunci a înțeles: fericirea nu vine din lucruri, ci din dragoste și prietenie!'),
      StoryPage(text: 'A treia dorință: "Vreau ca toți copiii din regat să aibă familii iubitoare și prieteni!" Genul a zâmbit: "Cea mai înțeleaptă dorință! Așa să fie!" Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_time_travel',
    title: 'Călătoria în Timp a lui Matei',
    genre: 'Sci-Fi',
    excerpt: 'Matei călătorește în trecut și învață lecții importante!',
    pages: [
      StoryPage(text: 'Matei găsește un ceas magic în mansarda bunicului. Când l-a rotit, WHOOSH! A călătorit în timp!'),
      StoryPage(text: 'S-a trezit în România anului 1900! A văzut copii lucrând din greu și studiind la lumina lumânării.'),
      StoryPage(text: '"Wow, aveau viețile atât de grele dar învățau cu pasiune!" s-a gândit Matei.'),
      StoryPage(text: 'A călătorit apoi în viitor, în anul 2100. Acolo, roboții ajutau la tot, dar copiii uitaseră cum să se joace afară!'),
      StoryPage(text: 'Matei s-a întors în prezent înțelegând: fiecare epocă are provocările sale. Important e să apreciezi ce ai! Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_music_magic',
    title: 'Vioaramagică',
    genre: 'Magical',
    excerpt: 'O vioară magică aduce bucurie unui sat întreg!',
    pages: [
      StoryPage(text: 'Într-un sat liniștit trăia un băiețel pe nume Vasile care iubea muzica. De ziua lui, bunicul i-a dăruit o vioară veche.'),
      StoryPage(text: '"Această vioară e specială," a spus bunicul. "Când o cânți cu inima curată, se întâmplă lucruri minunate!"'),
      StoryPage(text: 'Vasile a început să cânte. Florile au început să danseze, păsările au cântat în armonie, iar oamenii triști au zâmbit!'),
      StoryPage(text: 'Dar un băiat invidios i-a furat vioara. Când a încercat să cânte, nimic nu s-a întâmplat. Vioara răspundea doar la bunătate!'),
      StoryPage(text: 'Vasile l-a iertat și i-a învățat muzica. Împreună au cântat cele mai frumoase melodii! Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_brave_cat',
    title: 'Pisica Detectiv',
    genre: 'Mystery',
    excerpt: 'O pisică isteață rezolvă misterul pișicuțelor dispărute!',
    pages: [
      StoryPage(text: 'Felicia era o pisică elegantă care locuia în București. Avea un talent special: rezolva mistere!'),
      StoryPage(text: 'Într-o zi, trei pisicuțe au dispărut din cartier. "Trebuie să le găsesc!" a hotărât Felicia.'),
      StoryPage(text: 'A găsit urme de lăbuțe, fire de lână și o adresă misterioasă. Le-a urmat până la o casă veche.'),
      StoryPage(text: 'Acolo, a descoperit că pisicuțele nu erau răpite - găsiseră un loc cald și sigur pentru a se juca!'),
      StoryPage(text: 'Dar casa era nelocuită și periculoasă. Felicia i-a dus pe toți la un adăpost pentru animale frumos. Caz rezolvat! Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_space_adventure',
    title: 'Aventura Spațială a Sofiei',
    genre: 'Sci-Fi',
    excerpt: 'Sofia devine primul copil român în spațiu!',
    pages: [
      StoryPage(text: 'Sofia visa să devină astronaut. Învăța despre planete, stele și galaxii în fiecare zi.'),
      StoryPage(text: 'La un concurs național, Sofia a câștigat o călătorie pe Stația Spațială Internațională!'),
      StoryPage(text: 'În spațiu, totul plutea! Sofia făcea salto în aer și mânca mâncare din tuburi.'),
      StoryPage(text: 'A văzut România de sus - ca o copertă verde și albastră. "E atât de frumoasă!" a exclamat.'),
      StoryPage(text: 'Când s-a întors pe Pământ, Sofia a inspirat mii de copii să viseze mare. Visele pot deveni realitate! Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_forest_friends',
    title: 'Prietenii din Pădurea Bătrână',
    genre: 'Adventure',
    excerpt: 'Patru prieteni salvează pădurea de defrișare!',
    pages: [
      StoryPage(text: 'Mihai, Ana, Vlad și Ioana erau cei mai buni prieteni. Petreceau vacanțele în Pădurea Bătrână.'),
      StoryPage(text: 'Într-o zi, au auzit că pădurea va fi tăiată pentru a construi un mall. "Nu putem lăsa asta să se întâmple!"'),
      StoryPage(text: 'Au făcut o petiție, au vorbit la televiziune și au organizat o campanie de salvare a pădurii.'),
      StoryPage(text: 'Sute de oameni s-au alăturat cauzei! Autoritățile au ascultat și au declarat pădurea rezervație naturală.'),
      StoryPage(text: 'Cei patru prieteni au învățat: împreună, copiii pot schimba lumea! Sfârșitul.'),
    ],
  ),

  ExampleStory(
    id: 'ro_mountain_spirit',
    title: 'Spiritul Muntelui',
    genre: 'Fantasy',
    excerpt: 'Un copil întâlnește spiritul protector al munților!',
    pages: [
      StoryPage(text: 'Alexandru făcea drumeții cu familia în Retezat. S-a rătăcit pe un cărare și a ajuns la o peșteră misterioasă.'),
      StoryPage(text: 'În peșteră, o figură luminoasă a apărut. "Sunt Spiritul Muntelui. De ce ai venit aici, tinerele?"'),
      StoryPage(text: '"M-am rătăcit," a șoptit Alexandru. Spiritul a zâmbit: "Te voi ajuta, dar mai întâi trebuie să îndeplinești trei probe!"'),
      StoryPage(text: 'Prima probă: să ajute un căprior rănit. A doua: să planteze un copac. A treia: să promită că va proteja natura.'),
      StoryPage(text: 'Alexandru a trecut toate probele. Spiritul l-a condus înapoi la familie și i-a dăruit o pană magică de acvila.'),
      StoryPage(text: '"Când munții au nevoie de ajutor, pana va străluci!" De atunci, Alexandru a devenit protectorul naturii. Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_chef_adventure',
    title: 'Bucătarul Micșoritul',
    genre: 'Funny',
    excerpt: 'Un bucătar mic salvează balul regal cu rețete creative!',
    pages: [
      StoryPage(text: 'Toma era cel mai mic bucătar din Regat, dar avea cele mai mari idei!'),
      StoryPage(text: 'Regina organiza un bal și bucătarul șef s-a îmbolnăvit. "Toma, tu ești singurul disponibil!"'),
      StoryPage(text: 'Toma era nervos dar s-a gândit la cele mai creative rețete: tort în formă de castel, plăcinte care zburau, și supa care schimba culoarea!'),
      StoryPage(text: 'La bal, toți au rămas uimiți! "Cea mai delicioasă mâncare vreodată!" au exclamat nobilii.'),
      StoryPage(text: 'Regina l-a făcut Bucătar Șef Regal. Toma a dovedit: mărimea nu contează când ai talent și imaginație! Sfârșit Amuzant.'),
    ],
  ),

  ExampleStory(
    id: 'ro_winter_tale',
    title: 'Crăiasa Iernii',
    genre: 'Bedtime',
    excerpt: 'O poveste de iarnă liniștitoare despre prima zăpadă!',
    pages: [
      StoryPage(text: 'Crăiasa Iernii trăia într-un palat de gheață la Polul Nord. Odată pe an, zbura peste lume pictând totul în alb.'),
      StoryPage(text: 'În România, o fetiță pe nume Anca așteptă prima zăpadă cu nerăbdare. "Când va veni Crăiasa Iernii?"'),
      StoryPage(text: 'În noapte aia, Crăiasa a coborât blând. A atins fiecare copac, fiecare acoperiș, fiecare floare cu baghetamaga magică.'),
      StoryPage(text: 'Dimineață, Anca s-a trezit într-o lume albă și strălucitoare. A ieșit afară și a făcut cel mai frumos om de zăpadă.'),
      StoryPage(text: 'Seara, Crăiasa a trecut pe lângă fereastra ei și a zâmbit văzând copiii fericiți. Apoi a plecat mai departe, spre alte țări. Noapte bună! Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_library_adventure',
    title: 'Biblioteca Magică',
    genre: 'Learning',
    excerpt: 'Cărțile prind viață într-o bibliotecă fermecată!',
    pages: [
      StoryPage(text: 'Laura iubea să citească. Într-o zi, a descoperit o bibliotecă veche ascunsă într-un colț al orașului.'),
      StoryPage(text: 'Când a intrat, cărțile au început să vorbească! "Bine ai venit, iubitoare de povești!"'),
      StoryPage(text: 'O carte despre dinozauri s-a deschis și un T-Rex mic a ieșit! Era prieten, nu înfricoșător.'),
      StoryPage(text: 'O carte despre spațiu a creat un planetariu magic pe tavan. Laura a învățat despre toate planetele.'),
      StoryPage(text: 'Bibliotecara magică i-a explicat: "Fiecare carte e o ușă spre o nouă lume. Cu cât citești mai mult, cu atât descoperi mai mult!"'),
      StoryPage(text: 'Laura a devenit cea mai pasionată cititorică. Știa că fiecare carte e o aventură nouă! Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_inventor_kid',
    title: 'Micul Inventator',
    genre: 'Sci-Fi',
    excerpt: 'Un copil inventator creează dispozitive uimitoare!',
    pages: [
      StoryPage(text: 'George avea 10 ani și inventiva tot felul de lucruri: roboți, mașini zburătoare, și chiar o mașină de tradus animalele!'),
      StoryPage(text: 'Cea mai recentă invenție: Teleportorul de Teme! Îți făcea temele instant. Dar ceva n-a mers bine...'),
      StoryPage(text: 'În loc să facă temele, a teleportat toate cărțile din școală în camera lui! "Oops!"'),
      StoryPage(text: 'A trebuit să repare greșeala și să le ducă înapoi. Profesoara a fost impresionată de invenția lui.'),
      StoryPage(text: '"George, ești un geniu, dar amintește-te: unele lucruri trebuie făcute pe cont propriu, ca să înveți!" George a înțeles lecția. Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_dance_competition',
    title: 'Concursul de Dans',
    genre: 'School',
    excerpt: 'O fetiță timidă descoperă pasiunea pentru dans!',
    pages: [
      StoryPage(text: 'Emma era foarte timidă. La școală abia vorbea. Dar când era singură acasă, dansa cu pasiune!'),
      StoryPage(text: 'Școala organiza un concurs de dans. Emma voia să participe, dar era prea speriat.'),
      StoryPage(text: 'Profesoara de dans a văzut-o dansând în pauză. "Emma, ești talentată! Ar trebui să te înscrii!"'),
      StoryPage(text: 'Cu încurajare, Emma s-a înscris. A exersat săptămâni întregi. Ziua concursului a venit.'),
      StoryPage(text: 'La început era nervoasă, dar când muzica a început, s-a transformat! A dansat din suflet.'),
      StoryPage(text: 'A câștigat locul întâi! Mai important, și-a găsit încrederea în sine. Nu mai era timidă! Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_pirate_treasure',
    title: 'Comoara Piraților din Deltă',
    genre: 'Adventure',
    excerpt: 'O aventură pe Dunăre în căutarea unei comori pirate!',
    pages: [
      StoryPage(text: 'Legenda spunea că pirații turcești au ascuns o comoară în Delta Dunării. Doi frați, Dan și Ina, au decis să o caute.'),
      StoryPage(text: 'Au împrumutat o barcă și au pornit prin canalele Deltei. Peșcarii bătrâni le-au dat indicii.'),
      StoryPage(text: 'Au urmărit harta printre stufărișuri, pe lângă pelicani și prin peșterile de pe maluri.'),
      StoryPage(text: 'În cele din urmă, au găsit o insuliță ascunsă. Sub un salcie bătrân, au descoperit un cufăr!'),
      StoryPage(text: 'În cufăr nu era aur, ci instrumente vechi de navigație, hărți istorice și bijuterii vechi. Au donat totul muzeului.'),
      StoryPage(text: 'Aventura lor a devenit legendă! Au învățat că adevărata comoară e cunoașterea istoriei. Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_cloud_painter',
    title: 'Pictorul de Nori',
    genre: 'Fantasy',
    excerpt: 'Un copil descoperă că poate picta norii în diferite forme!',
    pages: [
      StoryPage(text: 'Bogdan avea un secret: când se concentra foarte tare, putea schimba forma norilor!'),
      StoryPage(text: 'Dimineața făcea nori în formă de animale. La prânz, pictia castele și balauri în cer.'),
      StoryPage(text: 'Într-o zi, soarele a dispărut sub nori întunecoși. Toată lumea era tristă.'),
      StoryPage(text: 'Bogdan a hotărât să ajute. A pictat cel mai frumos curcubeu în nori și a împrăștiat întunericul.'),
      StoryPage(text: 'Oamenii au zâmbit din nou. Nimeni nu știa secretul lui Bogdan, dar toți admirau norii frumoși.'),
      StoryPage(text: 'Bogdan a continuat să picteze cer, aducând bucurie tuturor. Arta lui era cea mai liberă! Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_soccer_dream',
    title: 'Visul de Fotbalist',
    genre: 'School',
    excerpt: 'Un băiat urmăriește visul de a deveni fotbalist!',
    pages: [
      StoryPage(text: 'Cosmin viseaza să joace fotbal pentru echipa națională. În fiecare zi se antrena din greu.'),
      StoryPage(text: 'La școală era mai mic decât ceilalți, așa că nu era ales în echipă. Era trist dar nu renunța.'),
      StoryPage(text: 'Antrenorul a văzut cât de mult exersa. "Cosmin, mărimea nu contează. Pasiunea și munca grea contează!"'),
      StoryPage(text: 'I-a dat o șansă. La primul meci, Cosmin a marcat golul victoriei! Era rapid și inteligent.'),
      StoryPage(text: 'De atunci, a devenit titular. A învățat: nu renunța niciodată la vis, indiferent de obstacole! Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_kindness_magic',
    title: 'Magia Bunătății',
    genre: 'Magical',
    excerpt: 'Faptele bune creează magie adevărată!',
    pages: [
      StoryPage(text: 'Într-un sat, oamenii și-au pierdut speranța. Totul era gri și trist. Nimeni nu mai zâmbea.'),
      StoryPage(text: 'O fetiță pe nume Daria a decis să schimbe asta. A început făcând câte o faptă bună pe zi.'),
      StoryPage(text: 'A ajutat o bătrânică să care cumpărăturile. Flori au înflorit unde au pășit.'),
      StoryPage(text: 'A hrănit pisici fără stăpân. O curcubeu a apărut deasupra lor.'),
      StoryPage(text: 'A împărțit prânzul cu un copil sărac. Soarele a strălucit mai puternic.'),
      StoryPage(text: 'Încet-încet, alții au început să facă și ei fapte bune. Satul s-a umplut de culoare, bucurie și magie adevărată! Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_smart_fox',
    title: 'Vulpița Deșteaptă',
    genre: 'Funny',
    excerpt: 'O vulpiță isteață învață o lecție importantă!',
    pages: [
      StoryPage(text: 'Vulpița Viorica se credea cea mai deșteaptă din pădure. Făcea mereu șotii altora.'),
      StoryPage(text: 'A păcălit ursul să-i dea mierea. A păcălit iepurele să-i dea morcovii. Râdea de toți.'),
      StoryPage(text: 'Într-o zi, a căzut într-o groapă adâncă. "Ajutor!" a strigat. Dar nimeni nu venea.'),
      StoryPage(text: 'Animalele și-au amintit de toate șotuele. "De ce să o ajutăm?" Viorica era desperată.'),
      StoryPage(text: 'În cele din urmă, o vrabiuță blândă a avut milă. A chemat ajutoare și au scos-o.'),
      StoryPage(text: 'Viorica a plâns. "Îmi pare rău! Am fost răut și egoistă!" De atunci, a devenit prietenă cu toți. A învățat că bunătatea bate viclenia! Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_rainbow_bridge',
    title: 'Podul Curcubeului',
    genre: 'Fantasy',
    excerpt: 'Copiii descoperă un pod magic făcut din curcubeu!',
    pages: [
      StoryPage(text: 'După o ploaie puternică, a apărut cel mai frumos curcubeu. Trei copii - Luca, Mia și Theo - au observat ceva magic!'),
      StoryPage(text: 'Curcubeul atingea pământul exact în parc! Au alergat să vadă și au descoperit un pod strălucitor.'),
      StoryPage(text: 'Au urcat pe pod. Fiecare culoare era un nivel: roșu pentru curaj, portocaliu pentru bucurie, galben pentru înțelepciune.'),
      StoryPage(text: 'La verde au întâlnit zâne, la albastru au văzut oceane magice, la indigo au visat împreună.'),
      StoryPage(text: 'La capătul curcubeului era un orășel de aur unde toate visurile devin realitate pentru copiii cu inimă curată.'),
      StoryPage(text: 'Au revenit acasă cu un secret magic: curcubeul e mereu acolo pentru cei care cred în magie! Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_guitar_hero',
    title: 'Chitara Magică',
    genre: 'Magical',
    excerpt: 'O chitară veche aduce muzică și fericire în sat!',
    pages: [
      StoryPage(text: 'În podul casei, Ștefan a găsit o chitară veche a bunicului. Când a cântat prima notă, ceva magic s-a întâmplat!'),
      StoryPage(text: 'Florile din grădină au început să danseze la ritmul muzicii. Păsările cântau în armonie.'),
      StoryPage(text: 'Vecinii au ieșit afară, atrași de melodia frumoasă. Toți zâmbeau și dansau.'),
      StoryPage(text: 'Un bătrân trist și-a amintit de tinerețe și a început să danseze. O mamă obosită și-a uitat grijile.'),
      StoryPage(text: 'Ștefan cânta în fiecare seară. Satul a devenit cel mai fericit loc, plin de muzică și iubire.'),
      StoryPage(text: 'A învățat că muzica are puterea de a vindeca inimi și de a uni oamenii. Sfârșit.'),
    ],
  ),

  ExampleStory(
    id: 'ro_homework_helper',
    title: 'Asistentul de Teme',
    genre: 'Funny',
    excerpt: 'Un robot ajutător creează situații amuzante!',
    pages: [
      StoryPage(text: 'Teo a primit un robot mic pentru ziua lui. "Pot să te ajut la teme!" a spus robotul vesel.'),
      StoryPage(text: 'La matematică, robotul calcula prea repede și făcea scântei. La română, inventa cuvinte ciudate.'),
      StoryPage(text: 'La desen, robotul a pictat întreaga cameră în loc să picteze pe hârtie! "Oops!"'),
      StoryPage(text: 'La educație fizică, robotul făcea 1000 de genuflexiuni pe secundă și toți râdeau.'),
      StoryPage(text: 'Teo a înțeles: e mai bine să-ți faci singur temele! Robotul a devenit prieten de joacă în schimb.'),
      StoryPage(text: 'Împreună au avut cele mai amuzante aventuri, dar temele le-a făcut Teo singur! Sfârșit Amuzant.'),
    ],
  ),
];
