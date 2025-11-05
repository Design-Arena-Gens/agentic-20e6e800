import fs from 'node:fs/promises';
import path from 'node:path';

const VERILOG_DIR = path.join(process.cwd(), 'public', 'verilog');

export type VerilogMeta = {
  name: string; // slug name (file basename without extension)
  filename: string; // actual filename within public/verilog
  title: string;
  description: string;
};

async function parseHeader(filePath: string): Promise<Pick<VerilogMeta, 'title' | 'description'>> {
  const raw = await fs.readFile(filePath, 'utf8');
  const lines = raw.split(/\r?\n/).slice(0, 20);
  let title = '';
  let description = '';
  for (const line of lines) {
    const t = line.match(/^\s*\/\/\s*Title:\s*(.*)$/i);
    if (t && !title) title = t[1].trim();
    const d = line.match(/^\s*\/\/\s*Description:\s*(.*)$/i);
    if (d && !description) description = d[1].trim();
    if (title && description) break;
  }
  if (!title) title = 'Verilog Module';
  if (!description) description = 'No description provided.';
  return { title, description };
}

export async function listVerilogExamples(): Promise<VerilogMeta[]> {
  const files = await fs.readdir(VERILOG_DIR);
  const vFiles = files.filter((f) => f.endsWith('.v'));
  const metas: VerilogMeta[] = await Promise.all(
    vFiles.map(async (filename) => {
      const filePath = path.join(VERILOG_DIR, filename);
      const { title, description } = await parseHeader(filePath);
      const name = path.basename(filename, '.v');
      return { name, filename, title, description };
    })
  );
  // stable sort by title
  metas.sort((a, b) => a.title.localeCompare(b.title));
  return metas;
}

export async function getVerilogSource(name: string): Promise<{ meta: VerilogMeta; source: string } | null> {
  const filename = `${name}.v`;
  const filePath = path.join(VERILOG_DIR, filename);
  try {
    const source = await fs.readFile(filePath, 'utf8');
    const { title, description } = await parseHeader(filePath);
    return { meta: { name, filename, title, description }, source };
  } catch {
    return null;
  }
}
