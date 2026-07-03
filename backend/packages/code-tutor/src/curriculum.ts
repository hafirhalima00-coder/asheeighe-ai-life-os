import type { CodeLanguage, TutorLevel, TutorLesson } from './index';

export const SUPPORTED_LANGUAGES: CodeLanguage[] = [
  {
    id: 'python',
    name: 'Python',
    icon: '🐍',
    description: 'Versatile language for AI, web, and automation',
    totalLessons: 30,
  },
  {
    id: 'javascript',
    name: 'JavaScript',
    icon: '⚡',
    description: 'The language of the web and beyond',
    totalLessons: 30,
  },
  {
    id: 'dart',
    name: 'Dart / Flutter',
    icon: '🎯',
    description: 'Build beautiful cross-platform apps',
    totalLessons: 30,
  },
  {
    id: 'html_css',
    name: 'HTML / CSS',
    icon: '🎨',
    description: 'Structure and style the web',
    totalLessons: 30,
  },
  {
    id: 'sql',
    name: 'SQL',
    icon: '🗃️',
    description: 'Query and manage databases',
    totalLessons: 30,
  },
  {
    id: 'git',
    name: 'Git',
    icon: '🌿',
    description: 'Version control for developers',
    totalLessons: 30,
  },
];

const PYTHON_LESSONS: TutorLesson[] = [
  // Level 1: Getting Started
  {
    id: 'py_001',
    levelNumber: 1,
    title: 'What is Programming?',
    description: 'Learn what programming is and why it matters.',
    type: 'concept',
    content: '## What is Programming?\n\nProgramming is giving instructions to a computer. Think of it like writing a recipe — step-by-step instructions that tell the computer exactly what to do.\n\n### Key Concepts\n- **Algorithm**: A step-by-step procedure to solve a problem\n- **Syntax**: The rules of writing code (like grammar in English)\n- **Bug**: An error in your code\n- **Debugging**: Finding and fixing bugs',
    codeExample: '# Your first Python program!\nprint("Hello, World!")\nprint("Welcome to PINKZ Code Tutor!")',
    expectedOutput: 'Hello, World!\nWelcome to PINKZ Code Tutor!',
    hints: [
      'Think of print() as telling the computer to say something out loud.',
      'Everything inside the quotes is what will be displayed.',
      'Each print() statement prints on a new line.',
    ],
    order: 1,
    estimatedMinutes: 10,
    xpReward: 15,
  },
  {
    id: 'py_002',
    levelNumber: 1,
    title: 'Variables and Data Types',
    description: 'Store information in variables.',
    type: 'concept',
    content: '## Variables\n\nVariables are like labeled boxes that store information.\n\n### Data Types\n- `str` — Text (strings)\n- `int` — Whole numbers (integers)\n- `float` — Decimal numbers\n- `bool` — True or False',
    codeExample: 'name = "Alice"\nage = 25\nheight = 5.6\nis_student = True\n\nprint(name)\nprint(age)\nprint(height)\nprint(is_student)',
    expectedOutput: 'Alice\n25\n5.6\nTrue',
    hints: [
      'Variables are created by typing a name, then =, then the value.',
      'Strings need quotes, numbers don\'t.',
      'True and False don\'t have quotes.',
    ],
    order: 2,
    estimatedMinutes: 15,
    xpReward: 20,
  },
  {
    id: 'py_003',
    levelNumber: 1,
    title: 'Your First Exercise',
    description: 'Practice what you learned with a hands-on exercise.',
    type: 'exercise',
    content: '## Exercise: Personal Introduction\n\nCreate variables for your name, age, and favorite hobby, then print them all out in a sentence.\n\n### Requirements:\n1. Create a `name` variable with your name\n2. Create an `age` variable with your age\n3. Create a `hobby` variable with your hobby\n4. Print each on a separate line',
    codeExample: '# Write your code here\nname = "Your Name"\nage = 0\nhobby = "coding"\n\nprint(name)\nprint(age)\nprint(hobby)',
    hints: [
      'Remember: strings need quotes around them.',
      'Numbers don\'t need quotes.',
      'Use separate print() statements for each variable.',
    ],
    order: 3,
    estimatedMinutes: 10,
    xpReward: 25,
  },
  {
    id: 'py_004',
    levelNumber: 1,
    title: 'Quiz: Python Basics',
    description: 'Test your knowledge of Python basics.',
    type: 'quiz',
    content: '## Quiz: Python Basics\n\nAnswer these questions to check your understanding.',
    codeExample: '# Quiz - answer each question\n\n# Q1: What will this print?\nx = 5\nprint(x)\n\n# Q2: What data type is "hello"?\n# a) int  b) str  c) float  d) bool\n\n# Q3: What does print() do?',
    hints: [
      'Think about what each variable stores.',
      'Strings are text enclosed in quotes.',
      'print() displays output to the screen.',
    ],
    order: 4,
    estimatedMinutes: 8,
    xpReward: 30,
  },
  // Level 2
  {
    id: 'py_005',
    levelNumber: 2,
    title: 'Operators and Expressions',
    description: 'Perform calculations with Python.',
    type: 'concept',
    content: '## Operators\n\n### Arithmetic Operators\n- `+` Addition\n- `-` Subtraction\n- `*` Multiplication\n- `/` Division\n- `//` Floor Division\n- `%` Modulo (remainder)\n- `**` Exponent',
    codeExample: 'a = 10\nb = 3\n\nprint(a + b)   # 13\nprint(a - b)   # 7\nprint(a * b)   # 30\nprint(a / b)   # 3.333...\nprint(a // b)  # 3\nprint(a % b)   # 1\nprint(a ** b)  # 1000',
    expectedOutput: '13\n7\n30\n3.3333333333333335\n3\n1\n1000',
    hints: [
      '// gives you the whole number part of division.',
      '% gives you the remainder after division.',
      '** raises a number to a power.',
    ],
    order: 5,
    estimatedMinutes: 15,
    xpReward: 20,
  },
  {
    id: 'py_006',
    levelNumber: 2,
    title: 'String Operations',
    description: 'Work with text in powerful ways.',
    type: 'concept',
    content: '## String Operations\n\n### Concatenation\nCombine strings with `+`\n\n### Repetition\nRepeat strings with `*`\n\n### f-strings\nEmbed variables directly in strings.',
    codeExample: 'first = "Pink"\nlast = "Z"\n\n# Concatenation\ fullName = first + " " + last\nprint(fullName)\n\n# f-string (modern way)\nprint(f"Hello, {first}!")\nprint(f"Name: {first} {last}")',
    expectedOutput: 'Pink Z\nHello, Pink!\nName: Pink Z',
    hints: [
      'f-strings start with f before the quote mark.',
      'Variables go inside curly braces {} in f-strings.',
      'You can put any expression inside {} in an f-string.',
    ],
    order: 6,
    estimatedMinutes: 15,
    xpReward: 20,
  },
];

const JAVASCRIPT_LESSONS: TutorLesson[] = [
  {
    id: 'js_001',
    levelNumber: 1,
    title: 'What is JavaScript?',
    description: 'Introduction to the language of the web.',
    type: 'concept',
    content: '## JavaScript\n\nJavaScript makes websites interactive. It runs in every browser and on servers (Node.js).\n\n### Why JavaScript?\n- Runs everywhere (browser, server, mobile)\n- Huge ecosystem (npm)\n- Essential for web development',
    codeExample: '// Your first JavaScript\nconsole.log("Hello, World!");\nconsole.log("Welcome to PINKZ!");',
    expectedOutput: 'Hello, World!\nWelcome to PINKZ!',
    hints: [
      'console.log() is how JavaScript prints output.',
      'Every statement ends with a semicolon (;).',
    ],
    order: 1,
    estimatedMinutes: 10,
    xpReward: 15,
  },
  {
    id: 'js_002',
    levelNumber: 1,
    title: 'Variables in JavaScript',
    description: 'Learn let, const, and var.',
    type: 'concept',
    content: '## Variables\n\nJavaScript has three ways to declare variables:\n- `const` — cannot be reassigned\n- `let` — can be reassigned\n- `var` — old way (avoid)',
    codeExample: 'const name = "Alice";\nlet age = 25;\n\n// age = 26; // This works\n// name = "Bob"; // This causes an error!\n\nconsole.log(name);\nconsole.log(age);',
    expectedOutput: 'Alice\n25',
    hints: [
      'Use const by default, let when you need to change a value.',
      'const means the variable name can never point to something else.',
    ],
    order: 2,
    estimatedMinutes: 12,
    xpReward: 20,
  },
];

const DART_LESSONS: TutorLesson[] = [
  {
    id: 'dart_001',
    levelNumber: 1,
    title: 'Introduction to Dart',
    description: 'Learn about Dart and why Flutter uses it.',
    type: 'concept',
    content: '## Dart Programming Language\n\nDart is the language behind Flutter. It\'s designed for building apps on any platform.\n\n### Why Dart?\n- Strongly typed (catches errors early)\n- AOT compilation for release builds\n- JIT compilation for fast development\n- Null safety built-in',
    codeExample: 'void main() {\n  print("Hello, Flutter!");\n  String name = "PINKZ";\n  int age = 2;\n  print("$name is $age years old!");\n}',
    expectedOutput: 'Hello, Flutter!\nPINKZ is 2 years old!',
    hints: [
      'Dart programs start with void main().',
      'String interpolation uses $variable or ${expression}.',
      'Every Dart file needs a main() function.',
    ],
    order: 1,
    estimatedMinutes: 10,
    xpReward: 15,
  },
];

const HTML_CSS_LESSONS: TutorLesson[] = [
  {
    id: 'html_001',
    levelNumber: 1,
    title: 'HTML Structure',
    description: 'Build the skeleton of a web page.',
    type: 'concept',
    content: '## HTML Basics\n\nHTML (HyperText Markup Language) uses tags to structure content.\n\n### Common Tags\n- `<html>` — Root element\n- `<head>` — Metadata\n- `<body>` — Visible content\n- `<h1>` to `<h6>` — Headings\n- `<p>` — Paragraphs\n- `<a>` — Links',
    codeExample: '<!DOCTYPE html>\n<html>\n<head>\n  <title>My Page</title>\n</head>\n<body>\n  <h1>Hello, World!</h1>\n  <p>Welcome to my website.</p>\n  <a href="https://pinkz.app">Visit PINKZ</a>\n</body>\n</html>',
    hints: [
      'HTML tags come in pairs: opening <tag> and closing </tag>.',
      'The DOCTYPE declaration tells the browser this is HTML5.',
      'Headings go from h1 (biggest) to h6 (smallest).',
    ],
    order: 1,
    estimatedMinutes: 10,
    xpReward: 15,
  },
];

const SQL_LESSONS: TutorLesson[] = [
  {
    id: 'sql_001',
    levelNumber: 1,
    title: 'What is SQL?',
    description: 'Introduction to querying databases.',
    type: 'concept',
    content: '## SQL — Structured Query Language\n\nSQL is used to communicate with databases. It lets you store, retrieve, and manipulate data.\n\n### Key Commands\n- `SELECT` — Get data\n- `INSERT` — Add data\n- `UPDATE` — Change data\n- `DELETE` — Remove data',
    codeExample: 'SELECT * FROM users;\n\nSELECT name, email FROM users WHERE age > 25;\n\nINSERT INTO users (name, email) VALUES (\'Alice\', \'alice@example.com\');',
    hints: [
      'SELECT * means get all columns.',
      'WHERE filters which rows to return.',
      'Strings in SQL use single quotes.',
    ],
    order: 1,
    estimatedMinutes: 10,
    xpReward: 15,
  },
];

const GIT_LESSONS: TutorLesson[] = [
  {
    id: 'git_001',
    levelNumber: 1,
    title: 'What is Git?',
    description: 'Learn about version control.',
    type: 'concept',
    content: '## Git — Version Control\n\nGit tracks changes to files so you can recall specific versions later.\n\n### Why Git?\n- Track every change to your code\n- Collaborate with others\n- Branch and merge safely\n- Undo mistakes',
    codeExample: '# Initialize a new repository\ngit init\n\n# Add files to staging\ngit add .\n\n# Commit changes\ngit commit -m "First commit"\n\n# Check status\ngit status\n\n# View history\ngit log --oneline',
    hints: [
      'git init creates a new Git repository.',
      'git add . stages all changed files.',
      'git commit saves staged changes with a message.',
    ],
    order: 1,
    estimatedMinutes: 10,
    xpReward: 15,
  },
];

const LESSON_MAP: Record<string, TutorLesson[]> = {
  python: PYTHON_LESSONS,
  javascript: JAVASCRIPT_LESSONS,
  dart: DART_LESSONS,
  html_css: HTML_CSS_LESSONS,
  sql: SQL_LESSONS,
  git: GIT_LESSONS,
};

export function getLessonsForLanguage(languageId: string): TutorLesson[] {
  return LESSON_MAP[languageId] ?? [];
}

export function getLessonById(languageId: string, lessonId: string): TutorLesson | undefined {
  const lessons = getLessonsForLanguage(languageId);
  return lessons.find((l) => l.id === lessonId);
}

export function getLevelsForLanguage(languageId: string): TutorLevel[] {
  const lessons = getLessonsForLanguage(languageId);
  const levelMap = new Map<number, TutorLesson[]>();

  for (const lesson of lessons) {
    const existing = levelMap.get(lesson.levelNumber) ?? [];
    existing.push(lesson);
    levelMap.set(lesson.levelNumber, existing);
  }

  const levels: TutorLevel[] = [];
  for (const [levelNum, levelLessons] of levelMap) {
    const title =
      levelNum <= 10
        ? 'Beginner'
        : levelNum <= 20
          ? 'Intermediate'
          : 'Advanced';

    levels.push({
      number: levelNum,
      title,
      topics: levelLessons.map((l) => l.title),
      lessons: levelLessons.sort((a, b) => a.order - b.order),
      requiredScore: levelNum * 10,
    });
  }

  return levels.sort((a, b) => a.number - b.number);
}

export function getNextLesson(languageId: string, completedLessonIds: string[]): TutorLesson | null {
  const lessons = getLessonsForLanguage(languageId);
  for (const lesson of lessons) {
    if (!completedLessonIds.includes(lesson.id)) {
      return lesson;
    }
  }
  return null;
}
