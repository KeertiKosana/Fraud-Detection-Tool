import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DatabaseGridComponent } from './database-grid.component';

describe('DatabaseGridComponent', () => {
  let component: DatabaseGridComponent;
  let fixture: ComponentFixture<DatabaseGridComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DatabaseGridComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DatabaseGridComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
