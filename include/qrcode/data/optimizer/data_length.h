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

#include <qrcode/data/encoders.h>
#include <qrcode/data/optimizer/optimize.h>

namespace qrcode::data::optimizer
{
    template<class Message>
    requires std::convertible_to<std::ranges::range_value_t<Message>, char>
    [[nodiscard]] constexpr auto data_length(
        Message&& message, nonull_encoders const& encoders) noexcept
    {
        auto length = 0;
        auto calc_length = [&length](auto const& range, auto const& encoder)
        {
            length += encoder.bit_count(range);
        };
        optimize(std::forward<Message>(message), encoders, calc_length);
        return length;
    }
}

