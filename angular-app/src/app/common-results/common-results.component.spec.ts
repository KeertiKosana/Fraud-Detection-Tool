import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CommonResultsComponent } from './common-results.component';

describe('CommonResultsComponent', () => {
  let component: CommonResultsComponent;
  let fixture: ComponentFixture<CommonResultsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CommonResultsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CommonResultsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
