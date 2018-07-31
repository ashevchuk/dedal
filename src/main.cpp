#include <boost/lambda/lambda.hpp>
#include <iostream>
#include <iterator>
#include <algorithm>

int main(int argc, char* argv[], char** envp) {
    std::cout << _BUILD_REPO_VERSION_ << "\n";

    using namespace boost::lambda;
    typedef std::istream_iterator<int> in;

    std::for_each( in(std::cin), in(), std::cout << (_1 * 3) << " " );
}
