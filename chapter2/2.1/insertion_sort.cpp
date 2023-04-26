#include <string>
#include <vector>
#include <cstdint>
#include <iostream>

void insertion_sort(std::vector<std::int32_t>& values, bool decreasing) {
  for (auto i=1; i < values.size(); i++) {
    int32_t key {values[i]};
    auto j = i - 1;
    bool condition { (!decreasing && values[j] > key) || (decreasing && values[j] < key)};
    while (j >= 0 && condition) {
      values[j + 1] = values[j];
      j--;
    }
    values[j + 1] = key;
  }
}

void print_vector(const std::vector<std::int32_t>& values) {
  for (auto value: values) {
    std::cout << value << '\n';
  }
}

void print_test_outputs(std::vector<int32_t>& values) {
  std::cout << "Before sort\n";
  print_vector(values);
  insertion_sort(values, false);
  std::cout << "After ascending sort\n";
  print_vector(values);
  insertion_sort(values, true);
  std::cout << "After descending sort\n";
  print_vector(values);
}

int main() {
  std::vector<std::int32_t> test1 {2, 10, 5, 7};
  print_test_outputs(test1);
}

