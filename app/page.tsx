import Link from 'next/link';
import { listVerilogExamples } from '@lib/verilog';

export default async function HomePage() {
  const examples = await listVerilogExamples();
  return (
    <div>
      <div className="grid">
        {examples.map((ex) => (
          <div className="card" key={ex.name}>
            <h3 style={{ marginTop: 0 }}>{ex.title}</h3>
            <p style={{ color: '#475569' }}>{ex.description}</p>
            <div style={{ display: 'flex', gap: '0.5rem' }}>
              <Link className="btn" href={`/example/${ex.name}`}>View</Link>
              <a className="btn" href={`/verilog/${ex.filename}`} download>
                Download
              </a>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
