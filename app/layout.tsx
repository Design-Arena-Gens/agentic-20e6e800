import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Verilog Examples',
  description: 'Well-crafted Verilog modules with readable code and examples.',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <header className="container">
          <h1>Verilog Examples</h1>
          <p className="subtitle">Reusable modules with clean implementations</p>
        </header>
        <main className="container">{children}</main>
        <footer className="footer container">Built for deployment on Vercel</footer>
      </body>
    </html>
  );
}
