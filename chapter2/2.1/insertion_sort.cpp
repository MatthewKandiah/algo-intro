#include <string>
#include <vector>
#include <cstdint>
#include <iostream>

void insertion_sort(std::vector<std::int32_t>& values) {
    for (auto i=1; i < values.size(); i++) {
        int32_t key {values[i]};
        auto j = i - 1;
        while (j > 0 && values[j] > key) {
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

int main() {
  std::vector<std::int32_t> test1 {2, 10, 5, 7};
  std::cout << "Before sort" << '\n';
  print_vector(test1);
  insertion_sort(test1);
  std::cout << "After ascending sort " << '\n';
  print_vector(test1);
}
