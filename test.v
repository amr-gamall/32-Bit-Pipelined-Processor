

module a(input a, b, c);

    reg aa, bb, cc;
    always @(*) begin
        {aa, bb, cc} = {a, b, c};
    end

endmodule