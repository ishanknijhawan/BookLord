class Categories {
  static List<String> storedCategories = [];

  static void addCategory(String cat) {
    storedCategories.add(cat);
  }

  static const List<Map<String, dynamic>> categories = [
    {
      'category': 'School',
      'further': [
        'Class VII or below',
        'Class IX',
        'Class X',
        'Class XI',
        'Class XII',
        'Others',
      ],
    },
    {
      'category': 'University',
      'further': [
        'Engineering',
        'Science',
        'Humanities',
        'Commerce',
        'Management',
        'Law',
        'Others'
      ],
    },
    {
      'category': 'Competitive',
      'further': [
        'CAT',
        'IIT JEE',
        'NEET/AIIMS',
        'UPSC',
        'BITSAT',
      ],
    },
    {
      'category': 'Novels',
      'further': [
        'Crime',
        'Action',
        'Thriller',
        'Romantic',
        'Fantasy',
        'Sci-Fi',
        'Documentary',
        'Others'
      ],
    },
    {
      'category': 'Reference',
      'further': [
        'test',
        'test',
      ],
    },
    {
      'category': 'Others',
      'further': [
        'Religious',
        'Spiritual',
        'Kids',
      ],
    },
  ];
}
