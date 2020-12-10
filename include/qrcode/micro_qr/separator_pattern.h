/*
 * The MIT License
 *
 * Copyright (c) 2020 Sebastian Bauer
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
#pragma once

#include <ranges>
#include <concepts>

#include <qrcode/structure/separator_pattern.h>
#include <qrcode/micro_qr/finder_pattern.h>

namespace qrcode::micro_qr
{
    using qrcode::structure::matrix;

    template<class T>
    [[nodiscard]] constexpr auto place_separator_pattern(matrix<T>& matrix)
    {
        place_separator_pattern(matrix, finder_location(), finder_pattern{}.size());
    }
}

#ifdef QRCODE_TESTS_ENABLED
#include <string_view>
#include <qrcode/structure/make_matrix.h>

namespace qrcode::micro_qr::test
{
    constexpr auto separator_patterns_are_placed_at_top_left_of_micro_symbol()
    {
        auto f = []()
        {
            using namespace std::literals;
            using namespace qrcode::structure;
            auto any_matrix = matrix<char>{{11,11}, module_traits<char>::make_free()};

            place_separator_pattern(any_matrix);

            return any_matrix == make_matrix<char>({11,11},
                ".......-..."
                ".......-..."
                ".......-..."
                ".......-..."
                ".......-..."
                ".......-..."
                ".......-..."
                "--------..."
                "..........."
                "..........."
                "..........."sv
            );        
        };
        static_assert(f());
    }
}
#endif