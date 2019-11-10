//Exemple how create simple bump mapping

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
const
    r = 40; // le rayon du cercle en pixels
var
    i, j, rx: Integer;
    l, a, p: Single;
begin
    BitBlt(temp.Canvas.Handle, 0, 0, Form1.Width, Form1.Height, buf.Canvas.Handle, 0, 0, SRCCOPY);

    for j := -r + 1 to r - 1 do
    begin
    rx := Round(sqrt(r * r - j * j));
    for i := -rx to rx do
    begin
        // pi / 2 = 1.57 -> optimisation
        l := sqrt(i * i + j * j);
        a := 1.57 * (-l / r + 1);
        p := l / (r * cos(a));
        temp.Canvas.Pixels[X + i, Y + j] := buf.Canvas.Pixels[X + Round(i * p), Y + Round(j * p)];
    end;
    end;

    BitBlt(Form1.Canvas.Handle, 0, 0, Form1.Width, Form1.Height, temp.Canvas.Handle, 0, 0, SRCCOPY);
end;

