enum EChallenge implements Comparable<EChallenge> {
  useEcoFriendlyProducts,
  deleteEmail,
  eatVegetarian,
  useColdWater;

  const EChallenge();

  @override
  int compareTo(EChallenge other) => index.compareTo(other.index);

  @override
  String toString() => name;

  static EChallenge fromName(String name) {
    switch (name) {
      case 'deleteEmail':
        return EChallenge.deleteEmail;
      case 'useEcoFriendlyProducts':
        return EChallenge.useEcoFriendlyProducts;
      case 'useColdWater':
        return EChallenge.useColdWater;
      case 'eatVegetarian':
        return EChallenge.useColdWater;
      default:
        throw Exception('Unknown EChallenge name: $name');
    }
  }
}
