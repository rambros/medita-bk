class CourseMeta {
  final String? duration, summary, description, language;
  final List? learnings, requirements;

  CourseMeta({
    this.duration,
    this.summary,
    this.description,
    this.learnings,
    this.requirements,
    this.language
  });

  factory CourseMeta.fromMap(Map<String, dynamic> meta) {
    return CourseMeta(
      duration: meta['duration'],
      summary: meta['summary'],
      description: meta['description'],
      learnings: meta['learnings'] ?? [],
      requirements: meta['requirements'] ?? [],
      language: meta['language']
    );
  }

  static Map<String, dynamic> getMap(CourseMeta d) {
    return {
      'duration': d.duration,
      'summary': d.summary,
      'description': d.description,
      'learnings': d.learnings,
      'requirements': d.requirements,
      'language': d.language
    };
  }
}