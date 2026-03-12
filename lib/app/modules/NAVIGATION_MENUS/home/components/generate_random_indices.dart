import 'dart:math';

// List<int> generateRandomIndices(int length) {
//     Random random = Random();
//     Set<int> randomIndices = {};
//     int maxSecondaryListViews = (length/2 ).round(); // Adjust the number of times the secondary ListView will appear

//     while (randomIndices.length < maxSecondaryListViews) {
//       int randomIndex = random.nextInt(length); // Generate a random index within the list length
//       randomIndices.add(randomIndex);
//     }

//     return randomIndices.toList()..sort(); // Sort the indices to maintain correct order
//   }

class RandomIndexGenerator {
  Random random = Random();
  Set<int> randomIndices = {}; // Store indices in a Set to avoid duplicates
  int currentLength = 0; // Track the list length
  int? minDistance;

  // Constructor with a minimum distance parameter
  RandomIndexGenerator({this.minDistance});

  // Method to generate random indices when length increases
  List<int> generateRandomIndices(int length, int minDistance) {
    // Update currentLength only if the new length is greater
    if (length > currentLength) {
      currentLength = length; // Update the list length
      int maxSecondaryListViews = (length / 2).round(); // Max number of indices

      int maxAttempts = 100; // To avoid infinite loops
      int attempts = 0;

      // Generate only one valid index
      while (randomIndices.length < maxSecondaryListViews &&
          attempts < maxAttempts) {
        int randomIndex = random.nextInt(
            currentLength); // Generate random index within the new length

        // Ensure that the new index has a minimum distance from all other indices
        bool isValid = true;
        for (int index in randomIndices) {
          if ((randomIndex - index).abs() < (minDistance)) {
            isValid = false;
            break;
          }
        }

        // Add the valid index and stop further generation
        if (isValid) {
          randomIndices.add(randomIndex);
          break;
        }

        attempts++;
      }
    }

    return randomIndices.toList()..sort(); // Return sorted list of indices
  }
}
