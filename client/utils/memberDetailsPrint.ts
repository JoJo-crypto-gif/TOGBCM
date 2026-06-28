import { Member, MemberStatus, Zone } from '../types';
import { getMemberDisplayName, getMemberTitles } from './memberName';
import { formatOccupation, parseOccupation } from './occupation';

interface PrintMemberDetailsOptions {
  member: Member;
  zones: Zone[];
  churchName?: string;
  churchLogo?: string;
}

const escapeHtml = (value: unknown) =>
  String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');

const cleanValue = (value?: string | number | boolean | null) => {
  if (typeof value === 'boolean') return value ? 'Yes' : 'No';
  if (value === undefined || value === null) return '';
  return String(value).trim();
};

const displayValue = (value?: string | number | boolean | null) => {
  const cleaned = cleanValue(value);
  return cleaned ? escapeHtml(cleaned) : '<span class="muted">Not specified</span>';
};

const formatDate = (value?: string | null) => {
  if (!value) return '';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return value;
  return date.toLocaleDateString(undefined, { year: 'numeric', month: 'long', day: 'numeric' });
};

const calculateAge = (dobString?: string | null): number | null => {
  if (!dobString) return null;
  const birthDate = new Date(dobString);
  if (Number.isNaN(birthDate.getTime())) return null;
  const today = new Date();
  let age = today.getFullYear() - birthDate.getFullYear();
  const monthDiff = today.getMonth() - birthDate.getMonth();
  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
    age--;
  }
  return age;
};

const getStatusClass = (status: MemberStatus) => {
  switch (status) {
    case MemberStatus.Active:
      return 'status-active';
    case MemberStatus.Visitor:
      return 'status-visitor';
    case MemberStatus.ExMember:
      return 'status-ex';
    default:
      return 'status-inactive';
  }
};

const detail = (label: string, value?: string | number | boolean | null) => `
  <div class="detail">
    <dt>${escapeHtml(label)}</dt>
    <dd>${displayValue(value)}</dd>
  </div>
`;

const section = (title: string, children: string, className = '') => `
  <section class="section ${className}">
    <h2>${escapeHtml(title)}</h2>
    <dl class="details-grid">
      ${children}
    </dl>
  </section>
`;

const getAssetUrl = (value?: string) => {
  if (!value) return '';
  try {
    return new URL(value, window.location.origin).toString();
  } catch {
    return value;
  }
};

export const openMemberDetailsPdf = ({
  member,
  zones,
  churchName = 'Ecclesia',
  churchLogo = '',
}: PrintMemberDetailsOptions) => {
  const printWindow = window.open('', '', 'width=980,height=900');
  if (!printWindow) return false;

  const zoneName = zones.find((zone) => zone.id === member.zoneId)?.name || 'Unassigned';
  const fullName = getMemberDisplayName(member) || 'Member';
  const generatedAt = new Date().toLocaleString(undefined, {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
  const age = calculateAge(member.dob);
  const occ = parseOccupation(member.occupation);
  const avatarUrl = getAssetUrl(member.avatarUrl);
  const logoUrl = getAssetUrl(churchLogo || '/logo.png');
  const children = Array.isArray(member.children) ? member.children : [];
  const fileName = `${fullName.replace(/[^a-z0-9]+/gi, '_').replace(/^_|_$/g, '') || 'member'}_profile`;

  const childrenHtml = children.length
    ? children
        .map((child, index) => `
          <tr>
            <td>${index + 1}</td>
            <td>${displayValue(child.name)}</td>
            <td>${displayValue(formatDate(child.dob))}</td>
            <td>${displayValue(child.dob ? calculateAge(child.dob) : null)}</td>
            <td>${displayValue(child.phone)}</td>
          </tr>
        `)
        .join('')
    : '<tr><td colspan="5" class="empty-row">No children recorded</td></tr>';

  const html = `<!doctype html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${escapeHtml(fileName)}</title>
  <style>
    @page { size: A4; margin: 14mm; }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      background: #eef2f7;
      color: #172033;
      font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      -webkit-print-color-adjust: exact;
      print-color-adjust: exact;
    }
    .sheet {
      width: min(100%, 920px);
      margin: 24px auto;
      background: #ffffff;
      border: 1px solid #dbe3ee;
      box-shadow: 0 24px 60px rgba(15, 23, 42, 0.12);
      overflow: hidden;
    }
    .brand-bar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 24px;
      padding: 24px 30px;
      border-bottom: 1px solid #e2e8f0;
      background: linear-gradient(135deg, #f8fafc 0%, #eef6f5 52%, #fff7ed 100%);
    }
    .brand {
      display: flex;
      align-items: center;
      gap: 14px;
      min-width: 0;
    }
    .logo {
      width: 54px;
      height: 54px;
      object-fit: contain;
      border-radius: 12px;
      background: #ffffff;
      border: 1px solid #e2e8f0;
      padding: 6px;
    }
    .brand h1 {
      margin: 0;
      font-size: 19px;
      line-height: 1.15;
      color: #0f172a;
    }
    .brand p,
    .generated p {
      margin: 4px 0 0;
      color: #64748b;
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.08em;
    }
    .generated { text-align: right; }
    .hero {
      position: relative;
      display: grid;
      grid-template-columns: 112px 1fr;
      gap: 22px;
      padding: 30px;
      background: #ffffff;
      border-bottom: 1px solid #e2e8f0;
    }
    .avatar {
      width: 112px;
      height: 112px;
      border-radius: 24px;
      object-fit: cover;
      border: 5px solid #f8fafc;
      background: #e2e8f0;
      box-shadow: 0 12px 26px rgba(15, 23, 42, 0.14);
    }
    .avatar-fallback {
      width: 112px;
      height: 112px;
      border-radius: 24px;
      border: 5px solid #f8fafc;
      background: #e2e8f0;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #64748b;
      font-size: 38px;
      font-weight: 900;
      box-shadow: 0 12px 26px rgba(15, 23, 42, 0.14);
    }
    .hero h2 {
      margin: 0;
      color: #0f172a;
      font-size: 30px;
      line-height: 1.08;
      letter-spacing: 0;
    }
    .subtitle {
      margin-top: 8px;
      color: #475569;
      font-size: 13px;
      font-weight: 700;
    }
    .chips {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-top: 16px;
    }
    .chip {
      display: inline-flex;
      align-items: center;
      border-radius: 999px;
      padding: 6px 10px;
      border: 1px solid #cbd5e1;
      background: #f8fafc;
      color: #334155;
      font-size: 11px;
      font-weight: 900;
      text-transform: uppercase;
      letter-spacing: 0.06em;
    }
    .status-active { background: #ecfdf5; color: #047857; border-color: #a7f3d0; }
    .status-inactive { background: #f1f5f9; color: #475569; border-color: #cbd5e1; }
    .status-visitor { background: #fffbeb; color: #b45309; border-color: #fde68a; }
    .status-ex { background: #fff1f2; color: #be123c; border-color: #fecdd3; }
    .content {
      padding: 24px 30px 30px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      background: #f8fafc;
    }
    .section {
      break-inside: avoid;
      page-break-inside: avoid;
      border: 1px solid #e2e8f0;
      border-radius: 14px;
      background: #ffffff;
      padding: 18px;
    }
    .section.full { grid-column: 1 / -1; }
    .section h2 {
      margin: 0 0 14px;
      padding-bottom: 10px;
      border-bottom: 1px solid #e2e8f0;
      color: #0f172a;
      font-size: 12px;
      font-weight: 900;
      text-transform: uppercase;
      letter-spacing: 0.12em;
    }
    .details-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 13px 16px;
      margin: 0;
    }
    .detail.full { grid-column: 1 / -1; }
    .detail dt {
      margin: 0 0 4px;
      color: #64748b;
      font-size: 9px;
      font-weight: 900;
      text-transform: uppercase;
      letter-spacing: 0.1em;
    }
    .detail dd {
      margin: 0;
      color: #172033;
      font-size: 12.5px;
      font-weight: 700;
      line-height: 1.45;
      overflow-wrap: anywhere;
      white-space: pre-wrap;
    }
    .muted {
      color: #94a3b8;
      font-weight: 600;
      font-style: italic;
    }
    .reason-box {
      grid-column: 1 / -1;
      margin-top: 2px;
      border: 1px solid #fecdd3;
      border-radius: 12px;
      padding: 12px;
      background: #fff1f2;
      color: #9f1239;
      font-size: 12px;
      font-weight: 800;
      line-height: 1.45;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      font-size: 12px;
      overflow: hidden;
      border-radius: 12px;
    }
    th {
      background: #eaf0f6;
      color: #475569;
      font-size: 9px;
      text-align: left;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      padding: 10px;
    }
    td {
      border-top: 1px solid #e2e8f0;
      padding: 10px;
      color: #172033;
      font-weight: 700;
      vertical-align: top;
    }
    .empty-row {
      text-align: center;
      color: #94a3b8;
      font-style: italic;
      font-weight: 600;
    }
    .notes {
      border-left: 4px solid #2563eb;
      background: #eff6ff;
      padding: 14px;
      border-radius: 12px;
      color: #1e3a8a;
      font-size: 12.5px;
      line-height: 1.55;
      font-weight: 700;
      white-space: pre-wrap;
    }
    .footer {
      display: flex;
      justify-content: space-between;
      gap: 20px;
      padding: 16px 30px 24px;
      background: #ffffff;
      color: #94a3b8;
      border-top: 1px solid #e2e8f0;
      font-size: 10px;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 0.08em;
    }
    @media print {
      body { background: #ffffff; }
      .sheet {
        width: 100%;
        margin: 0;
        border: 0;
        box-shadow: none;
      }
      .brand-bar { padding-top: 0; }
      .content { padding-bottom: 16px; }
    }
  </style>
</head>
<body>
  <main class="sheet">
    <header class="brand-bar">
      <div class="brand">
        <img class="logo" src="${escapeHtml(logoUrl)}" alt="" />
        <div>
          <h1>${displayValue(churchName)}</h1>
          <p>Member full details profile</p>
        </div>
      </div>
      <div class="generated">
        <p>Generated</p>
        <strong>${escapeHtml(generatedAt)}</strong>
      </div>
    </header>

    <section class="hero">
      ${
        avatarUrl
          ? `<img class="avatar" src="${escapeHtml(avatarUrl)}" alt="" />`
          : `<div class="avatar-fallback">${escapeHtml(member.firstName?.charAt(0) || 'M')}</div>`
      }
      <div>
        <h2>${escapeHtml(fullName)}</h2>
        <div class="subtitle">${displayValue(member.role || 'Member')} in ${displayValue(zoneName)}</div>
        <div class="chips">
          <span class="chip ${getStatusClass(member.status)}">${displayValue(member.status)}</span>
          <span class="chip">Member ID: ${displayValue(member.id)}</span>
          <span class="chip">Joined: ${displayValue(formatDate(member.joinDate))}</span>
          <span class="chip">Baptized: ${displayValue(member.isBaptized)}</span>
        </div>
        ${
          member.status === MemberStatus.ExMember && member.exMemberReason
            ? `<div class="reason-box"><strong>Reason for leaving:</strong> ${escapeHtml(member.exMemberReason)}</div>`
            : ''
        }
      </div>
    </section>

    <div class="content">
      ${section('Identity', `
        ${detail('Titles', getMemberTitles(member))}
        ${detail('First Name', member.firstName)}
        ${detail('Other Name(s)', member.otherName)}
        ${detail('Last Name', member.lastName)}
        ${detail('Gender', member.gender)}
        ${detail('Date of Birth', formatDate(member.dob))}
        ${detail('Age', age)}
        ${detail('Hometown', member.homeTown)}
        ${detail('Discovery Source', member.discoverySource)}
      `)}

      ${section('Contact & Residence', `
        ${detail('Email', member.email)}
        ${detail('Phone', member.phone)}
        ${detail('WhatsApp', member.whatsapp)}
        ${detail('Residential Address', member.address)}
        ${detail('Landmark', member.landmark)}
        ${detail('Emergency Contact', member.emergencyContact)}
        ${detail('Emergency Phone', member.emergencyPhone)}
      `)}

      ${section('Church Involvement', `
        ${detail('Status', member.status)}
        ${detail('Role / Ministry', member.role || 'Member')}
        ${detail('Assigned Zone', zoneName)}
        ${detail('Date Joined', formatDate(member.joinDate))}
        ${detail('Interest', member.interest)}
        ${detail("Brother's Keeper", member.brothersKeeper)}
        ${detail('Ex-member Reason', member.exMemberReason)}
      `)}

      ${section('Baptism', `
        ${detail('Baptized', member.isBaptized)}
        ${detail('Baptism Date', formatDate(member.baptismDate))}
        ${detail('Baptized By', member.baptizedBy)}
        ${detail('Baptism Church', member.baptismChurch)}
      `)}

      ${section('Education & Career', `
        ${detail('Highest Education', member.education)}
        ${detail('Employment Summary', formatOccupation(member.occupation))}
        ${detail('Employment Status', occ.status)}
        ${detail(occ.status === 'Student' ? 'Course of Study' : 'Role / Profession', occ.role)}
        ${detail(occ.status === 'Student' ? 'School Name' : 'Organization', occ.organization)}
        ${detail('Location', occ.location)}
      `)}

      ${section('Family & Relations', `
        ${detail('Marital Status', member.maritalStatus)}
        ${detail('Marriage Date', formatDate(member.marriageDate))}
        ${detail('Spouse Name', member.spouseName)}
        ${detail('Spouse Phone', member.spousePhone)}
        ${detail('Spouse Church', member.spouseChurch)}
        ${detail('Mother Name', member.motherName)}
        ${detail('Mother Status', member.motherStatus)}
        ${detail('Father Name', member.fatherName)}
        ${detail('Father Status', member.fatherStatus)}
      `)}

      <section class="section full">
        <h2>Children</h2>
        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>Name</th>
              <th>Date of Birth</th>
              <th>Age</th>
              <th>Phone</th>
            </tr>
          </thead>
          <tbody>${childrenHtml}</tbody>
        </table>
      </section>

      <section class="section full">
        <h2>Internal Notes</h2>
        <div class="notes">${member.notes ? escapeHtml(member.notes) : '<span class="muted">No internal notes recorded</span>'}</div>
      </section>
    </div>

    <footer class="footer">
      <span>Confidential church record</span>
      <span>${escapeHtml(fullName)}</span>
    </footer>
  </main>
  <script>
    window.onload = () => {
      setTimeout(() => {
        window.focus();
        window.print();
      }, 450);
    };
  </script>
</body>
</html>`;

  printWindow.document.write(html);
  printWindow.document.close();
  return true;
};
