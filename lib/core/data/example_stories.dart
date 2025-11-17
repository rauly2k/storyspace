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
];
