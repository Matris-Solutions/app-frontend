import { useMemo, useState, type ReactNode } from "react";

type RootScreen = "home" | "parishes" | "map" | "profile";
type Screen = RootScreen | "parish";
type IconName =
  | "bell"
  | "home"
  | "church"
  | "map"
  | "user"
  | "search"
  | "pin"
  | "clock"
  | "phone"
  | "arrow"
  | "calendar"
  | "cross"
  | "chevron"
  | "navigation";

const photos = {
  retreat:
    "https://images.unsplash.com/photo-1464207687429-7505649dae38?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080",
  interior:
    "https://images.unsplash.com/photo-1762967020958-6b2118ef93b3?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080",
  patrick:
    "https://images.unsplash.com/photo-1676247675471-318c831785cd?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080",
  sacred:
    "https://images.unsplash.com/photo-1624573830079-7fd9ce354be5?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080",
  mary:
    "https://images.unsplash.com/photo-1613686224427-29b757c04e0d?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080",
  joseph:
    "https://images.unsplash.com/photo-1615732224643-b000ac40c8b6?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080",
};

const parishes = [
  {
    name: "St. Patrick's",
    address: "451 Maple Avenue, Cedar Grove",
    mass: "Today · 5:30 PM",
    distance: "0.8 mi",
    image: photos.patrick,
  },
  {
    name: "Sacred Heart Church",
    address: "218 Willow Street, Brookfield",
    mass: "Tomorrow · 7:00 AM",
    distance: "2.0 mi",
    image: photos.sacred,
  },
  {
    name: "Our Lady of Grace",
    address: "72 Chapel Lane, Fairview",
    mass: "Today · 6:00 PM",
    distance: "3.4 mi",
    image: photos.mary,
  },
  {
    name: "St. Joseph Parish",
    address: "905 Garden Road, Riverside",
    mass: "Sunday · 8:30 AM",
    distance: "4.1 mi",
    image: photos.joseph,
  },
];

function Icon({ name, size = 22 }: { name: IconName; size?: number }) {
  const paths: Record<IconName, ReactNode> = {
    bell: (
      <>
        <path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9" />
        <path d="M10 21h4" />
      </>
    ),
    home: (
      <>
        <path d="m3 11 9-8 9 8" />
        <path d="M5 10v11h14V10M9 21v-7h6v7" />
      </>
    ),
    church: (
      <>
        <path d="M12 2v4M10 4h4M8 22v-8h8v8" />
        <path d="m4 22 1-11 7-5 7 5 1 11M2 22h20" />
      </>
    ),
    map: (
      <>
        <path d="m3 6 6-3 6 3 6-3v15l-6 3-6-3-6 3Z" />
        <path d="M9 3v15M15 6v15" />
      </>
    ),
    user: (
      <>
        <circle cx="12" cy="8" r="4" />
        <path d="M4 21a8 8 0 0 1 16 0" />
      </>
    ),
    search: (
      <>
        <circle cx="11" cy="11" r="7" />
        <path d="m20 20-4-4" />
      </>
    ),
    pin: (
      <>
        <path d="M20 10c0 5-8 12-8 12S4 15 4 10a8 8 0 1 1 16 0Z" />
        <circle cx="12" cy="10" r="2.5" />
      </>
    ),
    clock: (
      <>
        <circle cx="12" cy="12" r="9" />
        <path d="M12 7v5l3 2" />
      </>
    ),
    phone: (
      <path d="M7 3H4a1 1 0 0 0-1 1c0 9.4 7.6 17 17 17a1 1 0 0 0 1-1v-3l-4-2-2 2c-3.8-1.6-6.4-4.2-8-8l2-2Z" />
    ),
    arrow: (
      <>
        <path d="m15 18-6-6 6-6" />
      </>
    ),
    calendar: (
      <>
        <rect x="3" y="5" width="18" height="16" rx="2" />
        <path d="M16 3v4M8 3v4M3 10h18" />
      </>
    ),
    cross: (
      <>
        <path d="M12 2v20M7 7h10" />
      </>
    ),
    chevron: <path d="m9 18 6-6-6-6" />,
    navigation: (
      <path d="m4 4 16 6-7 3-3 7Z" />
    ),
  };

  return (
    <svg
      aria-hidden="true"
      fill="none"
      height={size}
      viewBox="0 0 24 24"
      width={size}
    >
      <g
        stroke="currentColor"
        strokeLinecap="round"
        strokeLinejoin="round"
        strokeWidth="1.8"
      >
        {paths[name]}
      </g>
    </svg>
  );
}

function Header({
  title,
  eyebrow,
  action,
}: {
  title: string;
  eyebrow?: string;
  action?: ReactNode;
}) {
  return (
    <header className="topbar">
      <div>
        {eyebrow && <p className="eyebrow">{eyebrow}</p>}
        <div className="app-title">{title}</div>
      </div>
      {action}
    </header>
  );
}

function BottomNav({
  screen,
  onChange,
}: {
  screen: Screen;
  onChange: (screen: RootScreen) => void;
}) {
  const items: { label: string; icon: IconName; screen: RootScreen }[] = [
    { label: "Home", icon: "home", screen: "home" },
    { label: "Parishes", icon: "church", screen: "parishes" },
    { label: "Map", icon: "map", screen: "map" },
    { label: "Profile", icon: "user", screen: "profile" },
  ];
  return (
    <nav aria-label="Main navigation" className="bottom-nav">
      {items.map((item) => (
        <button
          aria-current={screen === item.screen ? "page" : undefined}
          className={`nav-item ${screen === item.screen ? "active" : ""}`}
          key={item.label}
          onClick={() => onChange(item.screen)}
          type="button"
        >
          <span className="nav-icon">
            <Icon name={item.icon} size={21} />
          </span>
          <span>{item.label}</span>
        </button>
      ))}
    </nav>
  );
}

function HomeScreen({ onOpenParish }: { onOpenParish: () => void }) {
  return (
    <div className="screen">
      <div className="screen-content home-content">
        <Header
          eyebrow="Ordinary Time · Week XI"
          title="Parish Hub"
          action={
            <button aria-label="Notifications" className="icon-button" type="button">
              <Icon name="bell" />
              <span className="notification-dot" />
            </button>
          }
        />

        <section className="greeting">
          <p className="muted">Tuesday, June 17</p>
          <div className="display-title">Welcome back,<br />Tristen.</div>
        </section>

        <section aria-labelledby="readings-title" className="readings-card">
          <div className="readings-accent" />
          <div className="readings-heading">
            <div>
              <p className="card-kicker">Daily Readings</p>
              <div className="section-title" id="readings-title">Liturgy of the Word</div>
            </div>
            <span className="date-badge"><Icon name="cross" size={16} /></span>
          </div>
          <div className="reading">
            <span>First Reading</span>
            <i>2 Corinthians 8:1–9</i>
            <p>“Though he was rich, for your sake he became poor.”</p>
          </div>
          <div className="reading">
            <span>Responsorial Psalm</span>
            <i>Psalm 146:2, 5–9</i>
            <p>Praise the Lord, my soul!</p>
          </div>
          <div className="reading">
            <span>Gospel</span>
            <i>Matthew 5:43–48</i>
            <p>“Love your enemies and pray for those who persecute you.”</p>
          </div>
          <button className="text-button" type="button">Read full readings <Icon name="chevron" size={16} /></button>
        </section>

        <div className="section-row">
          <div className="section-title">Around the parish</div>
          <button className="small-link" type="button">View all</button>
        </div>

        <article className="event-card">
          <img alt="Friends overlooking a mountain lake during a retreat" src={photos.retreat} />
          <div className="event-overlay" />
          <div className="event-copy">
            <span className="event-tag">Registration open</span>
            <div className="event-title">Youth Retreat</div>
            <p><Icon name="calendar" size={15} /> July 18–20 · Camp St. Francis</p>
          </div>
        </article>

        <button className="church-tile" onClick={onOpenParish} type="button">
          <span className="church-icon"><Icon name="church" /></span>
          <span className="tile-copy">
            <small>My Home Church</small>
            <strong>St. Patrick's</strong>
            <span>Sunday Mass · 9:00 AM</span>
          </span>
          <Icon name="chevron" size={19} />
        </button>
      </div>
    </div>
  );
}

function DirectoryScreen({ onOpenParish }: { onOpenParish: () => void }) {
  const [query, setQuery] = useState("");
  const filtered = useMemo(
    () => parishes.filter((parish) => parish.name.toLowerCase().includes(query.toLowerCase())),
    [query],
  );

  return (
    <div className="screen">
      <div className="screen-content directory-content">
        <Header eyebrow="Find your community" title="Discover Parishes" />
        <label className="search-bar">
          <Icon name="search" size={20} />
          <input
            aria-label="Search parishes"
            onChange={(event) => setQuery(event.target.value)}
            placeholder="Search by parish or location"
            value={query}
          />
        </label>
        <div className="filter-row">
          <button className="filter-chip active" type="button">Nearby</button>
          <button className="filter-chip" type="button">Mass today</button>
          <button className="filter-chip" type="button">Confession</button>
        </div>
        <div className="result-label">{filtered.length} parishes near you</div>
        <div className="parish-list">
          {filtered.map((parish, index) => (
            <button
              className="parish-card"
              key={parish.name}
              onClick={index === 0 ? onOpenParish : undefined}
              type="button"
            >
              <img alt={`${parish.name} exterior`} src={parish.image} />
              <span className="parish-copy">
                <span className="parish-name-row">
                  <strong>{parish.name}</strong>
                  <span className="active-chip">Active</span>
                </span>
                <span className="address">{parish.address}</span>
                <span className="mass-line"><Icon name="clock" size={14} /> Next Mass: {parish.mass}</span>
              </span>
              <span className="distance">{parish.distance}</span>
            </button>
          ))}
          {!filtered.length && (
            <div className="empty-state">
              <Icon name="church" size={30} />
              <div>No parishes found</div>
              <p>Try another parish name or location.</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

function ParishDetail({ onBack }: { onBack: () => void }) {
  return (
    <div className="screen profile-screen">
      <div className="profile-hero">
        <img alt="Sunlit modern Catholic church interior and altar" src={photos.interior} />
        <div className="hero-shade" />
        <button aria-label="Go back" className="back-button" onClick={onBack} type="button">
          <Icon name="arrow" />
        </button>
        <span className="profile-label">My home parish</span>
      </div>
      <div className="profile-body">
        <div className="profile-title-row">
          <div>
            <p className="eyebrow">Welcome home</p>
            <div className="display-title compact">St. Patrick's</div>
          </div>
          <span className="verified-cross"><Icon name="cross" size={20} /></span>
        </div>
        <div className="contact-list">
          <div><Icon name="pin" size={18} /><span>451 Maple Avenue, Cedar Grove</span></div>
          <div><Icon name="phone" size={18} /><span>(555) 014-1888</span></div>
        </div>
        <div className="quick-actions">
          <button type="button"><Icon name="navigation" size={19} />Directions</button>
          <button type="button"><Icon name="phone" size={18} />Call office</button>
        </div>

        <section className="schedule-card">
          <div className="section-title">Worship schedule</div>
          <div className="schedule-group">
            <div className="schedule-icon"><Icon name="cross" size={19} /></div>
            <div className="schedule-copy">
              <strong>Sunday Mass</strong>
              <span><b>Sunday</b> 9:00 AM · 11:00 AM</span>
              <span><b>Saturday Vigil</b> 5:30 PM</span>
            </div>
          </div>
          <div className="divider" />
          <div className="schedule-group">
            <div className="schedule-icon gold"><Icon name="clock" size={18} /></div>
            <div className="schedule-copy">
              <strong>Reconciliation</strong>
              <span><b>Saturday</b> 3:30–4:45 PM</span>
              <span>Or by appointment</span>
            </div>
          </div>
        </section>

        <section className="news-section">
          <div className="section-row">
            <div className="section-title">Recent News</div>
            <button className="small-link" type="button">All news</button>
          </div>
          <article className="news-card">
            <span className="news-date">JUN <b>22</b></span>
            <span>
              <strong>Parish Feast Day Picnic</strong>
              <p>Join us after the 11:00 AM Mass for food, fellowship, and family activities.</p>
            </span>
          </article>
          <article className="news-card">
            <span className="news-date">JUN <b>26</b></span>
            <span>
              <strong>Evening of Adoration</strong>
              <p>Quiet prayer and Eucharistic adoration from 7:00–8:00 PM.</p>
            </span>
          </article>
        </section>
      </div>
    </div>
  );
}

function MemberProfile({ onOpenParish }: { onOpenParish: () => void }) {
  const accountItems: {
    title: string;
    detail: string;
    icon: IconName;
  }[] = [
    {
      title: "Personal information",
      detail: "Name, email, phone, and address",
      icon: "user",
    },
    {
      title: "Notifications",
      detail: "Mass reminders, news, and events",
      icon: "bell",
    },
  ];

  const supportItems: {
    title: string;
    detail: string;
    icon: IconName;
  }[] = [
    {
      title: "Privacy & security",
      detail: "Password and data preferences",
      icon: "cross",
    },
  ];

  return (
    <div className="screen">
      <div className="screen-content member-profile-content">
        <Header
          eyebrow="Your account"
          title="Profile"
          action={
            <button aria-label="Profile notifications" className="icon-button" type="button">
              <Icon name="bell" />
              <span className="notification-dot" />
            </button>
          }
        />

        <section className="member-identity">
          <div className="avatar-wrap">
            <div className="avatar" aria-label="Tristen Murphy profile photo">TM</div>
            <span className="avatar-status" />
          </div>
          <div className="member-name">Tristen Murphy</div>
          <p>tristen.murphy@example.com</p>
          <span className="member-chip">Parish member</span>
        </section>

        <section className="faith-summary">
          <div>
            <strong>12</strong>
            <span>Saved events</span>
          </div>
          <div>
            <strong>4</strong>
            <span>Ministries</span>
          </div>
        </section>

        <button className="home-parish-card" onClick={onOpenParish} type="button">
          <img alt="St. Patrick's Church exterior" src={photos.patrick} />
          <span>
            <small>My home parish</small>
            <strong>St. Patrick's</strong>
            <em><Icon name="pin" size={13} /> Cedar Grove · 0.8 mi</em>
          </span>
          <Icon name="chevron" size={19} />
        </button>

        <section className="profile-section">
          <div className="profile-section-heading">My Parish Hub</div>
          <div className="profile-menu">
            <button type="button">
              <span className="menu-icon"><Icon name="calendar" size={19} /></span>
              <span className="menu-copy"><strong>My events</strong><small>Registrations and saved events</small></span>
              <span className="menu-badge">3</span>
              <Icon name="chevron" size={17} />
            </button>
            <button type="button">
              <span className="menu-icon gold"><Icon name="church" size={19} /></span>
              <span className="menu-copy"><strong>My ministries</strong><small>Groups, schedules, and service</small></span>
              <Icon name="chevron" size={17} />
            </button>
          </div>
        </section>

        <section className="profile-section">
          <div className="profile-section-heading">Account</div>
          <div className="profile-menu">
            {accountItems.map((item) => (
              <button key={item.title} type="button">
                <span className="menu-icon"><Icon name={item.icon} size={19} /></span>
                <span className="menu-copy"><strong>{item.title}</strong><small>{item.detail}</small></span>
                <Icon name="chevron" size={17} />
              </button>
            ))}
          </div>
        </section>

        <section className="profile-section">
          <div className="profile-section-heading">Support</div>
          <div className="profile-menu">
            {supportItems.map((item) => (
              <button key={item.title} type="button">
                <span className="menu-icon"><Icon name={item.icon} size={19} /></span>
                <span className="menu-copy"><strong>{item.title}</strong><small>{item.detail}</small></span>
                <Icon name="chevron" size={17} />
              </button>
            ))}
          </div>
        </section>

        <button className="sign-out-button" type="button">Sign out</button>
        <p className="app-version">Parish Hub · Version 1.0.0</p>
      </div>
    </div>
  );
}

function MapScreen({ onOpenParish }: { onOpenParish: () => void }) {
  return (
    <div className="screen map-screen">
      <div className="map-canvas" aria-label="Map showing nearby parishes">
        <div className="park park-one">Riverside Park</div>
        <div className="park park-two" />
        <div className="water" />
        <div className="road road-one" />
        <div className="road road-two" />
        <div className="road road-three" />
        <div className="road road-four" />
        <span className="road-label label-one">MAPLE AVE</span>
        <span className="road-label label-two">CEDAR ROAD</span>
        <span className="place-label downtown">CEDAR GROVE</span>
        <button aria-label="St. Patrick's map pin" className="map-pin pin-one selected" type="button">
          <Icon name="church" size={18} />
        </button>
        <button aria-label="Sacred Heart map pin" className="map-pin pin-two" type="button">
          <Icon name="cross" size={16} />
        </button>
        <button aria-label="Our Lady of Grace map pin" className="map-pin pin-three" type="button">
          <Icon name="cross" size={16} />
        </button>
        <div className="map-top">
          <label className="map-search">
            <Icon name="search" size={20} />
            <input aria-label="Search the map" placeholder="Search this area" />
          </label>
          <button aria-label="Use current location" className="location-button" type="button">
            <Icon name="navigation" size={20} />
          </button>
        </div>
        <div className="map-controls">
          <button aria-label="Zoom in" type="button">+</button>
          <button aria-label="Zoom out" type="button">−</button>
        </div>
        <div className="map-sheet">
          <span className="sheet-handle" />
          <div className="selected-card">
            <img alt="Sacred Heart Church exterior" src={photos.sacred} />
            <div>
              <span className="active-chip">Open today</span>
              <div className="sheet-title">Sacred Heart Church</div>
              <p>2 miles away · 8 min drive</p>
              <span className="next-mass"><Icon name="clock" size={14} /> Next Mass at 5:30 PM</span>
            </div>
          </div>
          <button className="primary-button" onClick={onOpenParish} type="button">
            View parish <Icon name="chevron" size={17} />
          </button>
        </div>
      </div>
    </div>
  );
}

export default function App() {
  const [screen, setScreen] = useState<Screen>("home");
  const [previous, setPrevious] = useState<RootScreen>("home");

  const openParish = () => {
    if (screen !== "parish") {
      setPrevious(screen);
    }
    setScreen("parish");
  };

  return (
    <main className="app-shell">
      <div className="phone-frame">
        {screen === "home" && <HomeScreen onOpenParish={openParish} />}
        {screen === "parishes" && <DirectoryScreen onOpenParish={openParish} />}
        {screen === "map" && <MapScreen onOpenParish={openParish} />}
        {screen === "profile" && <MemberProfile onOpenParish={openParish} />}
        {screen === "parish" && <ParishDetail onBack={() => setScreen(previous)} />}
        <BottomNav screen={screen} onChange={setScreen} />
      </div>
    </main>
  );
}
