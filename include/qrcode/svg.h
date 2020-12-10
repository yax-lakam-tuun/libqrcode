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
#include <qrcode/structure/matrix.h>
#include <qrcode/structure/module_traits.h>
#include <qrcode/structure/horizontal_view.h>
#include <qrcode/structure/element_view.h>

namespace qrcode::detail
{
    using qrcode::structure::matrix;

    template<class Stream>
    constexpr auto white_background(Stream& stream)
    {
        stream << "<rect width=\"100%\" height=\"100%\" fill=\"#FFFFFF\"/>\n";
    }

    template<class Stream>
    constexpr auto header(Stream& stream)
    {
        stream << "<svg xmlns=\"http://www.w3.org/2000/svg\">\n";
    }

    template<class Stream>
    constexpr auto footer(Stream& stream)
    {
        stream << "</svg>\n";
    }

    template<class T, class Stream>
    [[nodiscard]] constexpr auto content(Stream& stream, matrix<T> const& symbol)
    {
        using namespace qrcode::structure;

        for (auto i : views::horizontal({0,0}, size(symbol)))
        {
            if (module_traits<T>::is_set(element_at(symbol, i)))
                stream << "<path d=\"M" << i.x << " " << i.y << " h1 v1 h-1 z\" />\n";
        }
    }
}

namespace qrcode
{
    using qrcode::structure::matrix;

    // example:
    //
    // matrix<...> symbol = ...;
    // std::ofstream file{"qrcode.svg", std::ofstream::out};
    // svg(file, symbol);
    //
    template<class T, class Stream>
    [[nodiscard]] constexpr auto svg(Stream& stream, matrix<T> const& symbol)
    {
        qrcode::detail::header(stream);
        qrcode::detail::white_background(stream);
        qrcode::detail::content(stream, symbol);
        qrcode::detail::footer(stream);
    }
}
