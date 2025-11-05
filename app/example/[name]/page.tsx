import Link from 'next/link';
import { getVerilogSource } from '@lib/verilog';

interface PageProps { params: { name: string } }

export default async function ExamplePage({ params }: PageProps) {
  const data = await getVerilogSource(params.name);
  if (!data) {
    return (
      <div>
        <p className="breadcrumb"><Link href="/">? Back</Link></p>
        <div className="card">
          <h3>Not found</h3>
          <p>No Verilog example named <code>{params.name}</code>.</p>
        </div>
      </div>
    );
  }
  const { meta, source } = data;
  return (
    <div>
      <p className="breadcrumb"><Link href="/">? Back</Link></p>
      <div className="card">
        <h2 style={{ marginTop: 0 }}>{meta.title}</h2>
        <p style={{ color: '#475569' }}>{meta.description}</p>
        <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '0.75rem' }}>
          <a className="btn" href={`/verilog/${meta.filename}`} download>Download .v</a>
        </div>
        <pre><code>{source}</code></pre>
      </div>
    </div>
  );
}
